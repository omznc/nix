{ config, pkgs, ... }:

{
  # Kernel security
  security = {
    protectKernelImage = true;
    forcePageTableIsolation = true;
    unprivilegedUsernsClone = config.virtualisation.containers.enable;
  };

  systemd.services.systemd-modules-load.serviceConfig.TimeoutStartSec = "20s";

  # Boot configuration
  boot = {
    # Kernel parameters for security and NVIDIA
    kernelParams = [
      "slab_nomerge"
      "page_poison=1"
      "page_alloc.shuffle=1"
      "debugfs=off"
      "modprobe.blacklist=nouveau"
    ];

    # Blacklist unnecessary kernel modules that could pose security risks
    blacklistedKernelModules = [
      # Amateur radio protocols
      "ax25"
      "netrom"
      "rose"

      # Uncommon filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    # Kernel sysctl security settings
    kernel.sysctl = {
      # Kernel security
      "kernel.kptr_restrict" = 2;
      "vm.max_map_count" = 2147483642; # For some games

      # Network security settings
      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = true;

      # Disable IP redirects
      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.default.secure_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;
    };
  };
}
