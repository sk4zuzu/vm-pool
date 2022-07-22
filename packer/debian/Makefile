SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := debian

RELEASE  := bullseye/20220711-1073
ARTIFACT := debian-11-generic-amd64-20220711-1073.qcow2
CHECKSUM := 6f6896d5740efb095d30e5118aeced30eda596dd5cddc28929767dc568f1833d84621a7b71d0aa403fcae3aef9c566ce7403b5a59dcaa74f6d3ea0e171ec38b0

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 10240

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
password: debian
ssh_pwauth: true
chpasswd:
  expire: false
endef

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://cloud.debian.org/images/cloud/$(RELEASE)/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "debian"
  ssh_password = "debian"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    execute_command = "sudo -iu root {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
      "remote-exec/03-systemd.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/cloud-config.yml:
	install -d $(SELF)/.cache/ && echo "$$CLOUD_CONFIG" >$@

$(SELF)/.cache/$(ARTIFACT).iso: $(SELF)/.cache/cloud-config.yml
	cloud-localds $@ $^

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: $(SELF)/.cache/$(ARTIFACT).iso Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
