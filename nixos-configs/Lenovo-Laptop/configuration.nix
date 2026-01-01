# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = "options kvm_intel nested=1";

#  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.initrd.kernelModules = ["ntsync"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
 networking.networkmanager = { 
 	enable = true;
 };

  # networking.bridges.br0.interfaces = [ "wlp8s0" ];

  # Network config for the vms


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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, bg";
    variant = "";
  };

  services.xserver.layout = "us, bg";
  services.xserver.xkbOptions = "grp:win_space_toggle";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

#####################################################################
#
#  hardware.graphics = {
#    enable = true;
#  };
#
#  services.xserver.videoDrivers = ["nvidia"];
#  hardware.nvidia.modesetting.enable = true;
#  hardware.nvidia.prime = {
#    sync.enable = true;
#    intelBusId = "PCI:0:0:0";
#    nvidiaBusId = "PCI:1:0:0";
#  };
#
#  hardware.nvidia.powerManagement.enable = true;
#  hardware.nvidia.powerManagement.finegrained = false;
#  hardware.nvidia.open = true;
#  hardware.nvidia.nvidiaSettings = true;
# Special config to load the latest (535 or 550) driver for the support of the 4070 SUPER

#####################################################################

  # Define a user account. Don't forget to set a password with ‘passwd’.me

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
  # virtualisation.qemu.networkingOptions = [ "-netdev tap,id=nd0,ifname=${tap_if_name},script=no,downscript=no,br=${tap_bridge_name}"  "-device virtio-net-pci,netdev=nd0,mac=${tap_macaddress}" ];
  
    virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.guest.enable = true;

#  virtualisation.virtualbox.guest.draganddrop = true;

  

  users.groups.libvirtd.members = ["wheel" "daniel"];

  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel Stoinov";
    extraGroups = [ "vboxusers" "networkmanager" "wheel" "docker" "libvirtd" ];
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
      kubebuilder
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
      delve
      gdlv
      helix
      xclip
      brave
      zellij
      sqlite
      mongosh
      jq
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
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #   unstable.neovim
     neovim
     git
     gcc
     gnumake
     ghostty
     zsh
     vscode
     google-chrome
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
  ];


 # fonts.packages = with pkgs; [ nerdfonts ];
 # fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
 fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
  nerd-fonts.hurmit
 ];


  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?




}
