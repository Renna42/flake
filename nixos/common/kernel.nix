{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  myKernelPackageFor = kernel: let
    # ccacheKernelStdenv = let
    #   newStdenv = pkgs.overrideCC kernel.stdenv (pkgs.ccacheWrapper.override {
    #     inherit (kernel.stdenv) cc;
    #   });
    #   mkCCachePlatform = platform:
    #     platform
    #     // {
    #       linux-kernel =
    #         platform.linux-kernel
    #         // {
    #           makeFlags =
    #             (platform.linux-kernel.makeFlags or [])
    #             ++ [
    #               "CC=${lib.getExe' newStdenv.cc "cc"}"
    #               "HOSTCC=${lib.getExe' newStdenv.cc "cc"}"
    #               "HOSTCXX=${lib.getExe' newStdenv.cc "c"}++"
    #             ];
    #         };
    #     };
    # in
    #   newStdenv.override {
    #     hostPlatform = mkCCachePlatform newStdenv.hostPlatform;
    #     buildPlatform = mkCCachePlatform newStdenv.buildPlatform;
    #   };
    # ccacheKernel = kernel.override {
    #   stdenv = ccacheKernelStdenv;
    #   buildPackages =
    #     pkgs.buildPackages
    #     // {
    #       stdenv = ccacheKernelStdenv;
    #     };
    # };
    kernelPackages = pkgs.linuxKernel.packagesFor kernel;

    nvidiaOverride = let
      patch = p: let
        patched = p.overrideAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ (with pkgs; [llvmPackages.libunwind]);

          # Somehow fixup phase is ran twice
          postFixup =
            (old.postFixup or "")
            + ''
              # Skip patching if latest patch is not available
              SED_ENCODE=$(cat "${pkgs.sources.nvidia-patch.src}/patch.sh" \
                | grep '"${old.version}"' \
                | head -n1 \
                | cut -d"'" -f2 \
                || echo "")
              SED_FBC=$(cat "${pkgs.sources.nvidia-patch.src}/patch-fbc.sh" \
                | grep '"${old.version}"' \
                | head -n1 \
                | cut -d"'" -f2 \
                || echo "")

              if [ -f "$out/lib/libnvidia-encode.so.${old.version}" ]; then
                echo "Patch $out/lib/libnvidia-encode.so.${old.version}"
                sed -i "$SED_ENCODE" "$out/lib/libnvidia-encode.so.${old.version}"
                LANG=C grep -obUaP "$(echo "$SED_ENCODE" | cut -d'/' -f3)" "$out/lib/libnvidia-encode.so.${old.version}"
              fi

              if [ -f "$out/lib/libnvidia-fbc.so.${old.version}" ]; then
                echo "Patch $out/lib/libnvidia-fbc.so.${old.version}"
                sed -i "$SED_FBC" "$out/lib/libnvidia-fbc.so.${old.version}"
                LANG=C grep -obUaP "$(echo "$SED_FBC" | cut -d'/' -f3)" "$out/lib/libnvidia-fbc.so.${old.version}"
              fi
            '';
        });
      in
        patched.overrideAttrs (old: {
          passthru =
            old.passthru
            // {
              settings = old.passthru.settings.overrideAttrs (old: {
                buildInputs = (old.buildInputs or []) ++ (with pkgs; [llvmPackages.libunwind]);
              });
              persistenced = old.passthru.persistenced.overrideAttrs (old: {
                buildInputs = (old.buildInputs or []) ++ (with pkgs; [llvmPackages.libunwind]);
              });
            };
        });
    in
      kernelPackages_:
        kernelPackages_.extend (
          final: prev:
            (lib.mapAttrs (
                n: v:
                  if lib.hasPrefix "nvidia_x11" n && lib.isDerivation v
                  then patch v
                  else v
              )
              prev)
            // {
              nvidiaPackages = lib.mapAttrs (n: patch) prev.nvidiaPackages;
            }
        );

    helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
  in
    lib.foldr (a: a)
    kernelPackages
    [
      helpers.kernelModuleLLVMOverride
      nvidiaOverride
    ];
in {
  options = {
    renna.kernel = lib.mkOption {
      type = lib.types.attrs;
      default =
        if pkgs.stdenv.isx86_64
        then pkgs.cachyosKernels.linux-cachyos-latest-lto
        else pkgs.linux;
    };
  };

  config = {
    boot = {
      initrd = {
        compressor = "zstd";
        compressorArgs = [
          "-19"
          "-T0"
        ];
        systemd.enable = true;
      };
      kernelPackages = myKernelPackageFor config.renna.kernel;
      kernelParams = [
        "cgroup_enable=memory"
        "ibt=off"
        "log_buf_len=1048576"
        "nvme_core.default_ps_max_latency_us=2147483647"
        "rcuupdate.rcu_cpu_stall_suppress=1"
        "split_lock_detect=off"
      ];
      kernel.sysctl = {
        # https://wiki.archlinux.org/title/Security#Kernel_hardening
        "kernel.dmesg_restrict" = 1;
        "kernel.kptr_restrict" = 1;
        "net.core.bpf_jit_harden" = 1;
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.yama.ptrace_scope" = 1;
        "kernel.kexec_load_disabled" = 1;

        "kernel.nmi_watchdog" = 0;

        # https://askubuntu.com/a/402940/1038244
        "vm.oom_kill_allocating_task" = 1;

        # https://github.com/NixOS/nixpkgs/pull/268121/files
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" =
          if config.swapDevices != []
          then 3 # Kernel default
          else if config.zramSwap.enable && config.zramSwap.algorithm == "zstd"
          then 0
          else 1;

        # Increase netdev receive queue
        # May help prevent losing packets
        "net.core.netdev_max_backlog" = "4096";

        # Set size of file handles and inode cache
        "fs.file-max" = "2097152";
      };
      bcache.enable = false;
      swraid.enable = false;
      supportedFilesystems = [
        "btrfs"
        "ext4"
        "exfat"
        "fat32"
        "xfs"
      ];
    };
  };
}
