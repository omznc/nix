# omznc/nix

just my nix configuration files. I basically have no idea what I'm doing

## tldr
- KDE Plasma 6 with SDDM display manager
- NVIDIA drivers with optimized settings
- Steam with GameMode support
- Zsh with Oh My Zsh and modern CLI tools
- Kernel hardening and network security
- Node.js, Bun, Python, Docker, and essential tools

## structure

```
.
├── configuration.nix      # Main system configuration
├── gaming.nix            # Gaming-related settings
├── security.nix          # Security hardening
├── shell.nix             # Shell and CLI tools
└── README.md            # This file
```

### security stuff
- Kernel image protection
- Blacklisted unnecessary kernel modules
- Network security hardening
- Page table isolation
- Memory poisoning

### shell/cli
- zsh with Oh My Zsh
- CLI replacements:
  - `eza` (enhanced ls)
  - `bat` (enhanced cat with syntax highlighting)
  - `fd` (enhanced find)
  - `ripgrep` (enhanced grep)
- smart directory navigation with `zoxide`
- fuzzy finding with `fzf`

## packages

### system packages
- `wget`
- `curl` 
- `git`
- `htop`
- `fastfetch` 
- `bleachbit`

### chat
- Slack, Telegram, Signal, Discord

### games
- Steam
- GameMode

### dev
- Node.js 24
- Python 3.14
- Docker & Docker Compose
- pnpm, Bun
- VS Code (FHS), Cursor

### locale
- **Timezone**: Europe/Sarajevo
- **Locale**: English (US) with Bosnian regional settings
- **Keyboard**: US layout


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

# Git 
gs → git status
ga → git add
gc → git commit
gp → git push
gl → git log --oneline
```


nix store garbage collection is configured to run weekly automatically