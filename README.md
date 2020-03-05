
SIMPLE VM ENVIRONMENT DONE IN LIBVIRT / QEMU ON LINUX
=====================================================

## 1. PURPOSE

Use local resources (cpu, memory and disk storage) for creating fully-automated environment for research and development.

## 2. REQUIREMENTS

### 2.1 SOFTWARE

__System packages__:
- cdrkit (for mkisofs)
- cloud-utils (for preparing VM initialization media)
- gcc
- git
- gnumake
- go (for building extra terraform providers)
- libvirt (devel)
- libxslt (devel)

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

Otherwise just install prerequisites listed above [2.1](#21-software) as you would normally do in your Linux distro.

All the "Hashicorp" providers can be installed manually or by `terraform` itself. The "libvirt" provider has to be built from source.

For your convenience we've included `makefile` scripts that can install and build all the requirements. If you've decided to go with the "makefile" way,
just make sure that your `$GOPATH` and `$PATH` variables point to existing directories beforehand:

```bash
$ cat ~/.profile
```
```bash
...
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
...
```

To install requirements  run:

```bash
$ make requirements _GOPATH_=~/go
```

To verify golang binaries run:

```bash
$ ls -1F ~/go/bin/
```
```
packer@
packer-1.5.1*
terraform@
terraform-0.12.19*
terraform-provider-libvirt@
terraform-provider-libvirt-0.6.1*
terragrunt@
terragrunt-0.21.11*
```

## 3. USAGE

Please look at [fake-vpc](https://github.com/sk4zuzu/fake-vpc) as it is very similar to this project.

![:thinking-face:](https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/twitter/233/thinking-face_1f914.png)

[//]: # ( vim:set ts=2 sw=2 et syn=markdown: )
