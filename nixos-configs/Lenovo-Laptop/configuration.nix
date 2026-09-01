{ config, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = config.nixpkgs.config;
  };
in

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./network-config.nix
      ./services-config.nix
      ./virtualization-config.nix
    ];



  # Set your time zone.
  time.timeZone = "Europe/Sofia";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bg_BG.UTF-8";
    LC_IDENTIFICATION = "bg_BG.UTF-8";
    LC_MEASUREMENT = "bg_BG.UTF-8";
    LC_MONETARY = "bg_BG.UTF-8";
    LC_NAME = "bg_BG.UTF-8";
    LC_NUMERIC = "bg_BG.UTF-8";
    LC_PAPER = "bg_BG.UTF-8";
    LC_TELEPHONE = "bg_BG.UTF-8";
    LC_TIME = "bg_BG.UTF-8";
  };


  programs = {
    virt-manager = {
      enable = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
          enable = true;
  	  theme = "robbyrussell";
	  plugins = [
	    "terraform"
	    "sudo"
	    "ansible"
	    "git"
  	  ];
      };
      shellAliases = {
        vim = "nvim";
	ll = "ls -l";
	k = "kubectl";
	update = "sudo nixos-rebuild switch";
      };
    };
    ## add this to make dynamic libraries
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
      ruff
      ];
    };
  };

  users.groups.libvirtd.members = ["wheel" "daniel"];

  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel Stoinov";
    extraGroups = [ "vboxusers" "networkmanager" "wheel" "docker" "libvirtd" "libvirt" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      terraform
      go-task
      kubectl
      kind
      vault
      crane
      tldr
      bat
      bat-extras.batman
      ripgrep
      wireshark
      tcpdump
      fzf
      lazygit
      yazi
      ansible
      tmux
      kubectx
      htop
      zsh-autosuggestions
      zsh-autocomplete
      zsh-syntax-highlighting
      zsh-powerlevel10k
      unstable.kubebuilder
      obsidian
      openssl
      gnupg
      qemu
      qemu_kvm
      virt-manager
      virt-viewer
      nodejs_24
      trace-cmd
      strace
      kernelshark
      perf-tools
      bcc
      bpftrace
      sysstat
      jetbrains.pycharm-community
      uv
      openresty
      kyverno
      gotools
      whois
      toybox
      fd
      gdlv
      helix
      xclip
      brave
      zellij
      sqlite
      mongosh
      jq
      unstable.kubernetes-controller-tools
      mupdf
      gdb
      unstable.delve
      unstable.gdlv
      gnused
      linuxPackages.perf
      asciinema_3
      gdb-dashboard
      man-pages-posix
      man-pages
      rizin
      cutter
      logisim-evolution
      unstable.opencode
      unstable.godot
      hugo
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install hyprland
  programs.hyprland = {
    enable = true;
  };


  environment.sessionVariables = {
  	# If your cursor becomes invidible
	# WLR_NO_HARDWARE_CURSORS = "1";
	# Hint electorn apps to use wayland
	NIXOS_OZONE_WL = "1";
  };

  environment.variables.EDITOR = "nvim";

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
      unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
    };
  };      


  programs.git = {
    enable = true;
    config = {
      user.name = "Daniel Stoinov";
      user.email = "daniel.stoinov@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
     unstable.neovim
     git
     gcc
     gnumake
     ghostty
     zsh
     unstable.vscode
     unstable.google-chrome
     curl
     go
     kubernetes-helm
     helmfile
     kitty
     python3Full
     stdenv.cc.cc.lib
     kns
     nushell
     k9s
     skaffold
     kubespy
     dive
     zlib
     lazydocker
     hyprland
     kitty
     waybar
     wofi
     nwg-look
     kanshi
     unstable.tree-sitter
     imagemagick
     stylua
  ];


 fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
  nerd-fonts.hurmit
 ];


  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "daniel" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
