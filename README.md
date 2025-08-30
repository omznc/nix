# omznc/nix

just my nix configuration files. I basically have no idea what I'm doing

## tldr
- gnome desktop environment with GDM display manager
- NVIDIA drivers with optimized settings and composition pipeline
- steam with GameMode support
- Zsh with Oh My Zsh, Pure prompt theme, and modern CLI tools
- kernel hardening, network security, and module blacklisting
- node.js 24, bun, Python 3.14, Docker, and essential development tools
- firefox with privacy-focused policies
- bluetooth support with GSConnect (KDE Connect)
- custom font configuration with Geist and Noto fonts
- alacritty terminal with custom configuration
- ntfs drive mounting support
- automatic system updates and garbage collection

## structure

```
.
├── configuration.nix      # main system configuration
├── gaming.nix            # gaming-related settings
├── security.nix          # security hardening
├── shell.nix             # shell and CLI tools
└── README.md            # this file
```

### security & hardening
- **kernel protection**:
  - kernel image protection enabled
  - page table isolation (PTI) forced
  - kernel pointer restriction (kptr_restrict=2)
- **memory security**:
  - page poisoning enabled
  - page allocation shuffling
  - slab merging disabled
- **network security**:
  - reverse path filtering enabled
  - ICMP broadcast ignore enabled
  - IPv4/IPv6 redirect protection
  - martian packet logging
- **module blacklisting**: 25+ unnecessary kernel modules blacklisted (filesystems, protocols)
- **boot security**: systemd-boot with EFI shell support
- **GPG/SSH integration**: GNOME Keyring and GPG agent enabled

### shell/cli
- **Zsh** with Oh My Zsh and Pure prompt theme
- **enhanced completions** and syntax highlighting
- **CLI tool replacements**:
  - `eza` (enhanced ls with icons)
  - `bat` (enhanced cat with syntax highlighting)
  - `fd` (enhanced find)
  - `ripgrep` (enhanced grep)
- **smart navigation**: `zoxide` for intelligent directory jumping
- **fuzzy finding**: `fzf` with Zsh integration
- **Nix helpers**: `nh` for simplified Nix operations

## packages

### system packages
- `wget`, `curl`, `git`, `gnupg`
- `htop`, `fastfetch`, `unzip`, `quota`
- `bleachbit`, `bluez`, `bluez-tools`
- `nixfmt-rfc-style` (Nix code formatter)

### chat
- Slack, Telegram, Signal, Discord

### games
- Steam
- GameMode

### dev
- **Node.js 24** with pnpm and bun
- **Python 3.14**
- **Docker & Docker Compose** with virtualization enabled
- **VS Code (FHS)** and Cursor
- **Git** with SSH GPG signing configured
- **GNOME Text Editor** and other GUI tools

### locale
- **timezone**: Europe/Sarajevo
- **locale**: English (US) with Bosnian regional settings
- **keyboard**: US layout

### browser
- **Firefox** with privacy-focused policies:
  - telemetry and studies disabled
  - optimized connection settings
  - GNOME extensions support enabled

### connectivity
- **Bluetooth** support with Blueman manager
- **GSConnect** integration for phone connectivity
- **NetworkManager** for network management
- **firewall** configured for GSConnect (ports 1714-1764)

### fonts
- **Geist** (serif/sans-serif)
- **Geist Mono Nerd Font** (monospace)
- **Font Awesome** icons
- **Noto** fonts (including emoji support)

### terminal
- **Alacritty** with custom configuration:
  - Geist Mono Nerd Font at size 12
  - Zsh shell integration
  - custom keybindings (Ctrl+Shift+C/V for copy/paste)
  - 10,000 line scrollback history

### storage
- **NTFS drive mounting** configured for Windows compatibility
- **fstrim** service enabled for SSD optimization

### system automation
- **automatic updates** at 11:00 UTC daily
- **Nix store garbage collection** weekly (30+ days old)
- **auto-optimization** of Nix store enabled


### aliases

```bash
# random tools
ls     → eza --icons
ll     → eza -la --icons
cat    → bat
grep   → rg
find   → fd
cd     → z

# management
rebuild     → sudo nixos-rebuild switch
home-rebuild → home-manager switch
update      → sudo nixos-rebuild switch --upgrade
al
# Git 
gs → git status
ga → git add
gc → git commit
gp → git push
gl → git log --oneline
```


**automation configured**:
- Nix store garbage collection runs weekly (deletes packages older than 30 days)
- system auto-upgrade runs daily at 11:00 UTC
- Nix store auto-optimization enabled for efficient storage