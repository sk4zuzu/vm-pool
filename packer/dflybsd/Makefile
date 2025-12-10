SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := dflybsd

RELEASE  := 6.4.2_REL
VERSION  := $(RELEASE)
ARTIFACT := dfly-x86_64-$(VERSION).iso
CHECKSUM := fdab09ac37cf427b8c01de5d54bfd1d7

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 10240

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = false
  iso_url      = "https://mirror-master.dragonflybsd.org/iso-images/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-serial", "stdio"],
  ]

  ssh_username     = "root"
  ssh_password     = "asd"
  shutdown_command = "/sbin/poweroff"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"

  boot_wait = "30s"

  boot_command = [
	"root<enter><wait1s>",
	"dhcpcd vtnet0<enter>",
	"ftp -o- http://{{.HTTPIP}}:{{.HTTPPort}}/00-bootstrap.sh | sh<enter>",
  ]
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    execute_command = "env {{.Vars}} sh {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-cloud-init.sh",
      "remote-exec/99-fixes.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	install -d $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
