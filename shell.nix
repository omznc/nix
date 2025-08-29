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

      # Pure prompt theme
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };

  # Terminal and shell tools
  environment.systemPackages = with pkgs; [
    ghostty
    starship # Alternative prompt (backup)
    eza # Better ls
    bat # Better cat with syntax highlighting
    fd # Better find
    ripgrep # Better grep
    fzf # Fuzzy finder
    zoxide # Smart cd
    nixfmt-rfc-style
    pure-prompt # Pure ZSH theme
  ];
}