SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := debian32

RELEASE  := 12
VERSION  := $(RELEASE).9.0
ARTIFACT := debian-$(VERSION)-i386-netinst.iso
CHECKSUM := b202bb0bb0b8227114306990d6ac317f02510606be53c4240249fca4b581dc81

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
  iso_url      = "https://cdimage.debian.org/debian-cd/$(VERSION)/i386/iso-cd/debian-$(VERSION)-i386-netinst.iso"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-serial", "stdio"],
  ]

  ssh_username = "debian"
  ssh_password = "asd"
  ssh_timeout  = "20m"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"

  boot_wait    = "10s"
  boot_command = [
    "<wait><esc>",
	"<wait>auto preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/00-preseed.cfg<enter>",
  ]
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

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: Makefile $(wildcard $(SELF)/remote-exec/*.sh) $(SELF)/remote-exec/00-preseed.cfg
	mkdir -p $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
