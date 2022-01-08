
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

### 2.2 INCLUDED AUTOMATION

If you're using [NixOS](https://nixos.org/) you can just enter Nix shell and continue from there:
```bash
$ nix-shell
```

## 3. USAGE

Please look at [fake-vpc](https://github.com/sk4zuzu/fake-vpc) as it is very similar to this project.

![:thinking-face:](https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/twitter/233/thinking-face_1f914.png)

[//]: # ( vim:set ts=2 sw=2 et syn=markdown: )
