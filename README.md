
SIMPLE VM ENVIRONMENT DONE IN LIBVIRT / QEMU ON LINUX
=====================================================

## 1. PURPOSE

Use local resources (cpu, memory and disk storage) for creating fully-automated environment for research and development.

## 2. REQUIREMENTS

### 2.1 SOFTWARE

__System packages__:
- cdrkit (for mkisofs)
- cloud-utils (for preparing VM initialization media)
- curl
- git
- unzip

__Base software__:
- [packer (Hashicorp)](https://releases.hashicorp.com/packer/)
- [terraform (Hashicorp)](https://releases.hashicorp.com/terraform/)
- [terragrunt (Github)](https://github.com/gruntwork-io/terragrunt/releases)

__Terraform providers__:
- [terraform-provider-libvirt (Github)](https://github.com/dmacvicar/terraform-provider-libvirt/releases)

### 2.2 RUNNING VM-POOL IN UBUNTU

```shell
apt update && apt install -y \
  cloud-image-utils \
  curl \
  genisoimage \
  libvirt-clients \
  libvirt-daemon-system \
  make \
  qemu \
  qemu-kvm \
  qemu-system-x86 \
  unzip
```

```shell
gawk -i inplace -f- /etc/libvirt/qemu.conf <<'EOF'
/^#*user[^=]*=/ { $0 = "user = \"root\"" }
/^#*group[^=]*=/ { $0 = "group = \"root\"" }
/^#*security_driver[^=]*=/ { $0 = "security_driver = \"none\"" }
{ print }
EOF
```

```shell
systemctl restart libvirtd
```

```shell
make requirements
```

```shell
make alpine-disk confirm a1-destroy a1-apply
```

### 2.3 RUNNING VM-POOL IN NIXOS

If you're using [NixOS](https://nixos.org/) you can just enter Nix shell and continue from there:

```shell
nix-shell
```

```shell
make requirements
```

```shell
make alpine-disk confirm a1-destroy a1-apply
```
