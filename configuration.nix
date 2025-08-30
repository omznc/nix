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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableGnomeExtensions = true;
      };
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.sessionstore.resume_from_crash" = false;
        "browser.aboutConfig.showWarning" = false;
        "network.http.max-connections" = 256;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.dns.disablePrefetch" = false;
        "network.prefetch-next" = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
  boot.loader.timeout = 0; # Disable boot menu

  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.systemd-boot.edk2-uefi-shell.sortKey = "y_edk2";

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Firewall configuration for GSConnect
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # GSConnect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # GSConnect
    ];
  };  

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Prefer Alacritty; exclude other terminals
  services.xserver.desktopManager.xterm.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];
  environment.variables = {
    TERMINAL = "alacritty";
    MOZ_DISABLE_CONTENT_SANDBOX = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "~/.cache/nvidia";
    # Fix NVIDIA cursor issues with GNOME
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_SIZE = "24";
  };

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
  services.fstrim.enable = true;

  users.users.omznc = {
    isNormalUser = true;
    description = "Omar Zunic";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      gnome-text-editor
      unstable.code-cursor-fhs
      slack
      unstable.telegram-desktop
      signal-desktop
      discord
      spotify
    ];
  };

  # Alacritty configuration for user omznc (TOML format)
  environment.etc."alacritty-omznc-config".text = ''
    # Alacritty configuration managed by NixOS
    # https://alacritty.org/config-alacritty.html

    [font]
    size = 12

    [font.normal]
    family = "GeistMono Nerd Font"
    style = "Regular"

    [font.bold]
    family = "GeistMono Nerd Font"
    style = "Bold"

    [font.italic]
    family = "GeistMono Nerd Font"
    style = "Italic"

    [terminal.shell]
    program = "/run/current-system/sw/bin/zsh"
    args = ["-l", "-c", "exec zsh"]

    [scrolling]
    history = 10000
    multiplier = 3

    [mouse]
    hide_when_typing = true

    [selection]
    semantic_escape_chars = ",│`|:\"' ()[]{}<>\t"
    save_to_clipboard = true

    [[keyboard.bindings]]
    key = "C"
    mods = "Control|Shift"
    action = "Copy"

    [[keyboard.bindings]]
    key = "V"
    mods = "Control|Shift"
    action = "Paste"

    [[keyboard.bindings]]
    key = "Insert"
    mods = "Shift"
    action = "PasteSelection"

    [[keyboard.bindings]]
    key = "Key0"
    mods = "Control"
    action = "ResetFontSize"

    [[keyboard.bindings]]
    key = "Equals"
    mods = "Control"
    action = "IncreaseFontSize"

    [[keyboard.bindings]]
    key = "Minus"
    mods = "Control"
    action = "DecreaseFontSize"

    [[keyboard.bindings]]
    key = "N"
    mods = "Control|Shift"
    action = "SpawnNewInstance"
  '';

  # Symlink the config to the user's home directory
  system.activationScripts.alacrittyUserConfig = ''
    mkdir -p /home/omznc/.config/alacritty
    ln -sf /etc/alacritty-omznc-config /home/omznc/.config/alacritty/alacritty.toml
    chown -R omznc:users /home/omznc/.config/alacritty
  '';

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    gnupg
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
    bluez
    bluez-tools
    gnomeExtensions.gsconnect
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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.steam-hardware.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    modesetting.enable = true;
    powerManagement.enable = false;  # Disable on desktop - can cause issues
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
      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";
    };
  };
}
