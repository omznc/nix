{ config, pkgs, ... }:

let
  unstable =
    import (builtins.fetchTarball "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz")
      {
        config = config.nixpkgs.config;
      };
in
{
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
    ./shell.nix
    ./security.nix
  ];

  programs.firefox.enable = true;

  # Mounting windows drives
  fileSystems."/run/media/omznc/HDDs" = {
    device = "/dev/disk/by-uuid/9E4E34EF4E34C1B7"; # use blkid to get UUID
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
      "windows_names"
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    geist-font
    nerd-fonts.geist-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [
      "Geist"
      "Noto Serif"
    ];
    sansSerif = [
      "Geist"
      "Noto Sans"
    ];
    monospace = [
      "GeistMono Nerd Font"
      "Noto Sans Mono"
    ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.systemd-boot.edk2-uefi-shell.sortKey = "y_edk2";

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Sarajevo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bs_BA.UTF-8";
    LC_IDENTIFICATION = "bs_BA.UTF-8";
    LC_MEASUREMENT = "bs_BA.UTF-8";
    LC_MONETARY = "bs_BA.UTF-8";
    LC_NAME = "bs_BA.UTF-8";
    LC_NUMERIC = "bs_BA.UTF-8";
    LC_PAPER = "bs_BA.UTF-8";
    LC_TELEPHONE = "bs_BA.UTF-8";
    LC_TIME = "bs_BA.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Prefer Ghostty; exclude other terminals
  services.xserver.desktopManager.xterm.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
  ];
  environment.variables.TERMINAL = "ghostty";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  users.users.omznc = {
    isNormalUser = true;
    description = "Omar Zunic";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      unstable.code-cursor-fhs
      slack
      unstable.telegram-desktop
      signal-desktop
      discord
    ];
  };

  # Ghostty configuration for user omznc
  environment.etc."ghostty-omznc-config".text = ''
    # Ghostty configuration managed by NixOS
    # Explicitly set zsh as the shell
    command = zsh

    # Window appearance
    window-padding-x = 4
    window-padding-y = 4

    # Font settings
    font-family = GeistMono Nerd Font
    font-size = 12

    # Theme
    background = 1e1e2e
    foreground = cdd6f4
  '';

  # Symlink the config to the user's home directory
  system.activationScripts.ghosttyUserConfig = ''
    mkdir -p /home/omznc/.config/ghostty
    ln -sf /etc/ghostty-omznc-config /home/omznc/.config/ghostty/config
    chown -R omznc:users /home/omznc/.config/ghostty
  '';

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    fastfetch
    unzip
    htop
    quota
    curl
    bleachbit
    nodejs_24
    python314
    vscode-fhs
    docker
    docker-compose
    pnpm
    unstable.bun
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  hardware.graphics = {
    enable = true;
  };

  # Docker virtualization
  virtualisation.docker.enable = true;

  services.blueman.enable = true;

  hardware.steam-hardware.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "11:00"; # UTC = 4am PDT / 3am PST
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Omar Zunic";
        email = "contact@omarzunic.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
