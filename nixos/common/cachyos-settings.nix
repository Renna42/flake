{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    renna.enableCachyosSettings = lib.mkEnableOption "Enable CachyOS' settings";
  };

  config = lib.mkIf config.renna.enableCachyosSettings ({
      boot = {
        kernelModules = [
          "ntsync"
        ];
        blacklistedKernelModules = [
          # Blacklist the Intel TCO Watchdog/Timer module
          "iTCO_wdt"
          # Blacklist the AMD SP5100 TCO Watchdog/Timer module (Required for Ryzen cpus)
          "sp5100_tco"
        ];
        extraModprobeConfig = ''
          #
          # NVreg_UsePageAttributeTable=1 (Default 0) - Activating the better memory
          # management method (PAT). The PAT method creates a partition type table at a
          # specific address mapped inside the register and utilizes the memory
          # architecture and instruction set more efficiently and faster. If your system
          # can support this feature, it should improve CPU performance.
          #
          # NVreg_InitializeSystemMemoryAllocations=0 (Default 1) - Disables clearing
          # system memory allocation before using it for the GPU. Potentially improves
          # performance, but at the cost of increased security risks. Write "options
          # nvidia NVreg_InitializeSystemMemoryAllocations=1" in
          # /etc/modprobe.d/nvidia.conf, if you want to return the default value. Note:
          # It is possible to use more memory (?)
          #
          # NVreg_DynamicPowerManagement=0x02 - Enables the use of dynamic power
          # management for Turing generation mobile cards, allowing the dGPU to be
          # powered down during idle time.
          #
          # NVreg_RegistryDwords=RmEnableAggressiveVblank=1
          # Reduce time spent in interrupt top half for low latency display interrupts
          # by deferring the work until later
          #
          # NVreg_EnableS0ixPowerManagement=1 (default 0) Enables S0ix for the NVIDIA GPU:
          # lets the device enter deep,
          # low-power idle states while the system uses s2idle (the S0 low-power idle path),
          # reducing battery drain—especially on laptops with recent Intel/AMD
          # platforms and Turing/Ampere/Ada GPUs
          #
          options nvidia NVreg_UsePageAttributeTable=1 \
              NVreg_InitializeSystemMemoryAllocations=0 \
              NVreg_RegistryDwords=RmEnableAggressiveVblank=1 \
              NVreg_DynamicPowerManagement=0x02 \
              NVreg_EnableS0ixPowerManagement=1
        '';
        kernel.sysctl = {
          # The sysctl swappiness parameter determines the kernel's preference for pushing anonymous pages or page cache to disk in memory-starved situations.
          # A low value causes the kernel to prefer freeing up open files (page cache), a high value causes the kernel to try to use swap space,
          # and a value of 100 means IO cost is assumed to be equal.
          "vm.swappiness" = "100";

          # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache).
          # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
          "vm.vfs_cache_pressure" = "50";

          # Contains, as bytes, the number of pages at which a process which is
          # generating disk writes will itself start writing out dirty data.
          "vm.dirty_bytes" = "268435456";

          # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
          # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
          # but consecutive on swap space - that means they were swapped out together. (Default is 3)
          # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
          "vm.page-cluster" = "0";

          # Contains, as bytes, the number of pages at which the background kernel
          # flusher threads will start writing out dirty data.
          "vm.dirty_background_bytes" = "67108864";

          # The kernel flusher threads will periodically wake up and write old data out to disk.  This
          # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
          "vm.dirty_writeback_centisecs" = "1500";

          # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
          # Disable NMI watchdog
          "kernel.nmi_watchdog" = "0";

          # Restricting access to kernel pointers in the proc filesystem
          "kernel.kptr_restrict" = "2";

          # Increase netdev receive queue
          # May help prevent losing packets
          "net.core.netdev_max_backlog" = "4096";

          # Set size of file handles and inode cache
          "fs.file-max" = "2097152";
        };
      };
    }
    // {
      services.udev.path = [
        pkgs.bash
        pkgs.hdparm
      ];

      services.udev.extraRules =
        # 30-zram.rules
        ''
          # When used with ZRAM, it is better to prefer page out only anonymous pages,
          # because it ensures that they do not go out of memory, but will be just
          # compressed. If we do frequent flushing of file pages, that increases the
          # percentage of page cache misses, which in the long term gives additional
          # cycles to re-read the same data from disk that was previously in page cache.
          # This is the reason why it is recommended to use high values from 100 to keep
          # the page cache as hermetic as possible, because otherwise it is "expensive"
          # to read data from disk again. At the same time, uncompressing pages from ZRAM
          # is not as expensive and is usually very fast on modern CPUs.
          #
          # Also it's better to disable Zswap, as this may prevent ZRAM from working
          # properly or keeping a proper count of compressed pages via zramctl.
          ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", \
              RUN+="/bin/sh -c 'echo N > /sys/module/zswap/parameters/enabled'"
        ''
        # 50-sata.rules
        + ''
          # SATA Active Link Power Management
          ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", \
              ATTR{link_power_management_supported}=="1", \
              ATTR{link_power_management_policy}=="*", \
              ATTR{link_power_management_policy}="max_performance"
        ''
        # 60-ioschedulers.rules
        + ''
          # HDD
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
              ATTR{queue/scheduler}="bfq"

          # SSD
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
              ATTR{queue/scheduler}="mq-deadline"

          # NVMe SSD
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
              ATTR{queue/scheduler}="none"
        ''
        # 69-hdparm.rules
        + ''
          ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
              ATTRS{id/bus}=="ata", RUN+="/usr/bin/hdparm -B 254 -S 0 /dev/%k"
        ''
        # 71-nvidia.rules
        + ''
          # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
          ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
              ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
              TEST=="power/control", ATTR{power/control}="auto"

          # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
          ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
              ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
              TEST=="power/control", ATTR{power/control}="on"
        '';
    }
    // {
      services.zram-generator.settings."zram0" = {
        "compression-algorithm" = "zstd";
        "zram-size" = "ram";
        "swap-priority" = "100";
        "fs-type" = "swap";
      };
    }
    // {
      systemd.settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";

        DefaultLimitNOFILE = "2048:2097152";
      };

      systemd.user.extraConfig = ''
        DefaultLimitNOFILE=1024:1048576
      '';

      services.journald.extraConfig = ''
        SystemMaxUse=50M
      '';
    }
    // {
      systemd.services = {
        "user@".serviceConfig = {
          Delegate = "cpu cpuset io memory pids";
        };
        "rtkit-daemon".serviceConfig = {
          LogLevelMax = "info";
        };
      };
    }
    // {
      systemd.tmpfiles.rules = [
        # Clear all coredumps that were created more than 3 days ago
        "d /var/lib/systemd/coredump 0755 root root 3d"

        # Improve performance for applications that use tcmalloc
        # https://github.com/google/tcmalloc/blob/master/docs/tuning.md#system-level-optimizations
        "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"

        # THP Shrinker has been added in the 6.12 Kernel
        # Default Value is 511
        # THP=always policy vastly overprovisions THPs in sparsely accessed memory areas, resulting in excessive memory pressure and premature OOM killing
        # 409 means that any THP that has more than 409 out of 512 (80%) zero filled filled pages will be split.
        # This reduces the memory usage, when THP=always used and the memory usage goes down to around the same usage as when madvise is used, while still providing an equal performance improvement
        "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
      ];
    }
    // {
      services.resolved.enable = true;
      networking.networkmanager.dns = "systemd-resolved";
    });
}
