{ config, pkgs, ... }:

{
  # Gaming-related configuration
  programs = {
    gamemode.enable = true;
    steam.enable = true;
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam
    gamemode
  ];
}
