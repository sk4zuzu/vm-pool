SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := netbsd

RELEASE  := 9.3
VERSION  := $(RELEASE)
ARTIFACT := NetBSD-$(VERSION)-amd64.iso
CHECKSUM := 7e7f03bfd0584480cd11ed8833963310e34361d105498a028a2ebf3c10354171

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 12288

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = false
  iso_url      = "https://cdn.netbsd.org/pub/NetBSD/NetBSD-$(VERSION)/images/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  net_device     = "virtio-net"
  disk_interface = "virtio"

  qemuargs = [
    ["-serial", "stdio"],
  ]

  ssh_username     = "root"
  ssh_password     = "asd"
  shutdown_command = "/sbin/poweroff"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"

  boot_wait = "20s"

  boot_command = [
	"<leftCtrlOn>c<leftCtrlOff><wait1s>",
	"dhcpcd vioif0<enter>",
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
	mkdir -p $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
