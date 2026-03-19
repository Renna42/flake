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
        consoleLogLevel = 3;
        kernelModules = [
          "ntsync"
        ];
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
      hardware.block = {
        defaultScheduler = "mq-deadline";
        defaultSchedulerRotational = "bfq";
        scheduler."nvme[0-9]*" = "none";
      };
    }
    // {
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
              RUN+="${pkgs.bash}/bin/sh -c 'echo N > /sys/module/zswap/parameters/enabled'"
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
    }
    // {
      systemd.tmpfiles.rules = [
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
    });
}
