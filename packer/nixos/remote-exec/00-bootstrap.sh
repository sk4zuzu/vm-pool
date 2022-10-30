#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

sfdisk /dev/vda <<< ';'

mkfs.ext4 -L nixos /dev/vda1

mount LABEL=nixos /mnt/

nixos-generate-config --root /mnt/

cat >/mnt/etc/nixos/configuration.nix <<EOF
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bash_5 bat
    fd file
    git
    htop
    iproute2
    jq
    mc
    nftables
    ripgrep
    tcpdump tmux
    unzip
    vim
    zip
  ];

  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable  = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device  = "/dev/vda";
  boot.growPartition       = true;

  networking.hostName        = "nixos";
  networking.useDHCP         = false;
  networking.useNetworkd     = true;
  networking.firewall.enable = false;

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
  };

  services.openssh.enable = true;

  services.cloud-init.enable         = true;
  services.cloud-init.network.enable = true;

  system.stateVersion = "$(nixos-version | cut -d. -f-2)";
}
EOF

nixos-install

sync
