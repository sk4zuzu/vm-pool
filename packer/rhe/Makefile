
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $(SELF)/Makefile.IN

NAME := rhe

VERSION  := 7.6
ARTIFACT := rhel-server-$(VERSION)-update-5-x86_64-kvm.qcow2
CHECKSUM := 12ff4e11fd3d0a4de5af33344070196f4061e86121fbfe9f297d02ae52336200

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 10240

PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
ssh_pwauth: true
password: redhat
chpasswd:
  expire: false
endef

define Packerfile
{
  "builders": [
    {
      "type": "qemu",
      "accelerator": "kvm",

      "disk_image": "true",
      "iso_url": "file://$(SELF)/../../files/$(ARTIFACT)",
      "iso_checksum": "$(CHECKSUM)",
      "iso_checksum_type": "sha256",

      "disk_size": "$(DISK_SIZE)",

      "qemuargs": [
        ["-fda", "$(SELF)/.cache/$(ARTIFACT).iso"]
      ],

      "ssh_username": "cloud-user",
      "ssh_password": "redhat",

      "output_directory": "$(SELF)/.cache/output/",
      "vm_name": "packer-$(NAME).qcow2",

      "headless": $(HEADLESS)
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "environment_vars": [
        "SUBSCRIPTION_USERNAME=$(SUBSCRIPTION_USERNAME)",
        "SUBSCRIPTION_PASSWORD=$(SUBSCRIPTION_PASSWORD)"
      ],
      "execute_command": "sudo -iu root {{.Vars}} {{.Path}}",
      "scripts": [
        "remote-exec/01-basics.sh"
      ]
    }
  ]
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/cloud-config.yml:
	mkdir -p $(SELF)/.cache/ && echo "$$CLOUD_CONFIG" >$@

$(SELF)/.cache/$(ARTIFACT).iso: $(SELF)/.cache/cloud-config.yml
	cloud-localds $@ $^

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: $(SELF)/.cache/$(ARTIFACT).iso Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	packer build -force - <<< "$$Packerfile"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/

# vim:ts=4:sw=4:noet:syn=make:
