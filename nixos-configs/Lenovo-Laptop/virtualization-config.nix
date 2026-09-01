
{ config, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = config.nixpkgs.config;
  };
in

{

  virtualisation.docker.enable = true;
  # virtualisation.incus.enable = true;

  boot.initrd.systemd.enable = false;
  virtualisation.xen = {
    enable = false;
  };

  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      packages = [(pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
        }).fd];
      };
    };
  };
 
  virtualisation.virtualbox.host.enable = true;

  users.groups.libvirtd.members = ["wheel" "daniel"];

}
