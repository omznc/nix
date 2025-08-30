{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "";
      plugins = [
        "git"
        "docker"
        "npm"
        "node"
      ];
    };
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    shellAliases = {
      # Modern CLI tools
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      cd = "z";

      # System shortcuts
      rebuild = "sudo nixos-rebuild switch";
      home-rebuild = "home-manager switch";
      update = "sudo nixos-rebuild switch --upgrade";

      # nh CLI shortcuts
      nhh = "nh home switch .";
      nhs = "nh os switch .";
      nhus = "nh os switch -u .";

      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
    };

    interactiveShellInit = ''
      # Initialize zoxide (smart cd)
      eval "$(zoxide init zsh)"

      # FZF integration
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # Enhanced completion settings
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Pure prompt theme
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };

  # Terminal and shell tools
  environment.systemPackages = with pkgs; [
    alacritty
    starship # Alternative prompt (backup)
    eza # Better ls
    bat # Better cat with syntax highlighting
    fd # Better find
    ripgrep # Better grep
    fzf # Fuzzy finder
    zoxide # Smart cd
    nixfmt-rfc-style
    pure-prompt # Pure ZSH theme
    zsh-completions # Enhanced completion functions
    nh # Yet another nix helper
  ];
}