#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

sfdisk /dev/vda <<< ';'

mkfs.ext4 -L nixos /dev/vda1

mount LABEL=nixos /mnt/

nixos-generate-config --root /mnt/ --no-filesystems

install -d /mnt/etc/nixos/configuration.nix.d/

cat >/mnt/etc/nixos/configuration.nix <<EOF
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    bash bat
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

  imports = [ ./hardware-configuration.nix ] ++ (lib.pipe ./configuration.nix.d [
    builtins.readDir
    (lib.filterAttrs (name: _: lib.hasSuffix ".nix" name))
    (lib.mapAttrsToList (name: _: ./configuration.nix.d + "/\${name}"))
  ]);

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  swapDevices = [];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.kernelParams       = [ "net.ifnames=0" "biosdevname=0" ];
  boot.growPartition      = true;

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
    password     = "asd";
  };

  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    "" "\${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  services.openssh.enable = true;

  services.cloud-init.enable         = true;
  services.cloud-init.network.enable = true;
  services.cloud-init.settings       = { datasource_list = [ "NoCloud" ]; };

  system.stateVersion = "$(nixos-version | cut -d. -f-2)";
}
EOF

nixos-install

nixos-enter -- nix-collect-garbage -d

sync
