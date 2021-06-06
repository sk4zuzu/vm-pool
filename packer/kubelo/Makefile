SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := kubelo

VERSION  := 20.04
RELEASE  := focal
ARTIFACT := ubuntu-$(VERSION)-server-cloudimg-amd64.vmdk
CHECKSUM := 1b10d0975c0307769b004e1dd2db0c6fe42e2059db5899b1443afda662802b14

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 10240

PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
password: ubuntu
ssh_pwauth: true
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
      "iso_url": "https://cloud-images.ubuntu.com/releases/$(RELEASE)/release/$(ARTIFACT)",
      "iso_checksum": "$(CHECKSUM)",

      "memory": "$(MEMORY)",
      "disk_size": "$(DISK_SIZE)",

      "qemuargs": [
        ["-fda", "$(SELF)/.cache/$(ARTIFACT).iso"]
      ],

      "ssh_username": "ubuntu",
      "ssh_password": "ubuntu",

      "output_directory": "$(SELF)/.cache/output/",
      "vm_name": "packer-$(NAME).qcow2",

      "headless": $(HEADLESS)
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "execute_command": "sudo -iu root {{.Vars}} {{.Path}}",
      "scripts": [
        "remote-exec/01-basics.sh",
        "remote-exec/02-docker.sh",
        "remote-exec/03-kubernetes.sh",
        "remote-exec/04-iscsi.sh"
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
	$(SELF)/../../bin/packer build -force - <<< "$$Packerfile"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
