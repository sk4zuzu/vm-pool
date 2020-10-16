SELF := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
NAME := redhat

include $(SELF)/subscription.mk

VERSION  := 7.8
ARTIFACT := rhel-server-$(VERSION)-x86_64-kvm.qcow2
CHECKSUM := ce4943d38e00a5c81272ebd3f3542b2d9557382d1c331c46ed553fdcca778b2d

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 12288

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
