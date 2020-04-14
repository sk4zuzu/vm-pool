
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

SSH_OPTIONS := -o ForwardAgent=yes \
               -o StrictHostKeyChecking=no \
               -o GlobalKnownHostsFile=/dev/null \
               -o UserKnownHostsFile=/dev/null


.PHONY: all confirm yes requirements

all:

confirm: yes
yes:
	@: $(eval AUTO_APPROVE := --auto-approve)

requirements: binaries extras


.PHONY: binaries extras

binaries:
	make -f $(SELF)/Makefile.BINARIES

extras:
	make -f $(SELF)/Makefile.EXTRAS


.PHONY: ubu-disk k8s-disk rhe-disk

ubu-disk:
	cd $(SELF)/packer/ubu/ && make build

k8s-disk:
	cd $(SELF)/packer/k8s/ && make build

rhe-disk:
	cd $(SELF)/packer/rhe/ && make build


.PHONY: asd-init asd-apply asd-destroy

asd-init:
	cd $(SELF)/LIVE/asd1/ && terragrunt init

asd-apply: asd-init ubu-disk
	cd $(SELF)/LIVE/asd1/ && terragrunt apply $(AUTO_APPROVE)

asd-destroy: asd-init
	-make -f Makefile.SNAPSHOT clean-x1
	cd $(SELF)/LIVE/asd1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: k8s-init k8s-apply k8s-destroy

k8s-init:
	cd $(SELF)/LIVE/k8s1/ && terragrunt init

k8s-apply: k8s-init k8s-disk
	cd $(SELF)/LIVE/k8s1/ && terragrunt apply $(AUTO_APPROVE)

k8s-destroy: k8s-init
	-make -f Makefile.SNAPSHOT clean-k1
	cd $(SELF)/LIVE/k8s1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: zxc-init zxc-apply zxc-destroy

zxc-init:
	cd $(SELF)/LIVE/zxc1/ && terragrunt init

zxc-apply: zxc-init rhe-disk
	cd $(SELF)/LIVE/zxc1/ && terragrunt apply $(AUTO_APPROVE)

zxc-destroy: zxc-init
	-make -f Makefile.SNAPSHOT clean-y1
	cd $(SELF)/LIVE/zxc1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: asd-backup asd-restore

asd-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-x1

asd-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-x1


.PHONY: k8s-backup k8s-restore

k8s-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-k1

k8s-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-k1


.PHONY: zxc-backup zxc-restore

zxc-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-y1

zxc-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-y1


.PHONY: become ssh-asd ssh-k8s ssh-zxc

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

ssh-asd: ssh-asd10

ssh-k8s: ssh-k8s10

ssh-zxc: ssh-zxc10

ssh-asd%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.2.$* $(BECOME_ROOT)

ssh-k8s%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.3.$* $(BECOME_ROOT)

ssh-zxc%:
	@ssh $(SSH_OPTIONS) cloud-user@10.30.2.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/ubu/ && make clean
	-cd $(SELF)/packer/k8s/ && make clean
	-cd $(SELF)/packer/rhe/ && make clean

# vim:ts=4:sw=4:noet:syn=make:
