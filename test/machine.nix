{ config, pkgs, ... }:
{
  virtualisation.memorySize = pkgs.lib.mkOverride 150 3072;
  virtualisation.diskSize = 2048;
  environment.systemPackages = [ pkgs.firefox pkgs.apacheAntOpenJDK pkgs.oraclejdk pkgs.subversion pkgs.maven3 ];
  system.copySystemConfiguration = false;
}

