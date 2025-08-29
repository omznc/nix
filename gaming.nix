{ config, pkgs, ... }:

{
  # Gaming-related configuration
  programs = {
    gamemode.enable = true;
  };

  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam
    gamemode
  ];
}
