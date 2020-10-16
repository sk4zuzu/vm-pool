
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


.PHONY: centos-disk kubelo-disk redhat-disk ubuntu-disk

centos-disk:
	cd $(SELF)/packer/centos/ && make build

kubelo-disk:
	cd $(SELF)/packer/kubelo/ && make build

redhat-disk:
	cd $(SELF)/packer/redhat/ && make build

ubuntu-disk:
	cd $(SELF)/packer/ubuntu/ && make build


.PHONY: c1-init c1-apply c1-destroy

c1-init:
	cd $(SELF)/LIVE/c1/ && terragrunt init

c1-apply: c1-init centos-disk
	cd $(SELF)/LIVE/c1/ && terragrunt apply $(AUTO_APPROVE)

c1-destroy: c1-init
	-make -f Makefile.SNAPSHOT clean-c1
	cd $(SELF)/LIVE/c1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: asd-init asd-apply asd-destroy

asd-init:
	cd $(SELF)/LIVE/asd1/ && terragrunt init

asd-apply: asd-init ubu-disk
	cd $(SELF)/LIVE/asd1/ && terragrunt apply $(AUTO_APPROVE)

asd-destroy: asd-init
	-make -f Makefile.SNAPSHOT clean-x1
	cd $(SELF)/LIVE/asd1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: kub-init kub-apply kub-destroy

kub-init:
	cd $(SELF)/LIVE/kub1/ && terragrunt init

kub-apply: kub-init kub-disk
	cd $(SELF)/LIVE/kub1/ && terragrunt apply $(AUTO_APPROVE)

kub-destroy: kub-init
	-make -f Makefile.SNAPSHOT clean-k1
	cd $(SELF)/LIVE/kub1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: zxc-init zxc-apply zxc-destroy

zxc-init:
	cd $(SELF)/LIVE/zxc1/ && terragrunt init

zxc-apply: zxc-init rhe-disk
	cd $(SELF)/LIVE/zxc1/ && terragrunt apply $(AUTO_APPROVE)

zxc-destroy: zxc-init
	-make -f Makefile.SNAPSHOT clean-y1
	cd $(SELF)/LIVE/zxc1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: c1-backup c1-restore

c1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-c1

c1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-c1


.PHONY: asd-backup asd-restore

asd-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-x1

asd-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-x1


.PHONY: kub-backup kub-restore

kub-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-k1

kub-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-k1


.PHONY: zxc-backup zxc-restore

zxc-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-y1

zxc-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-y1


.PHONY: become c1-ssh asd-ssh kub-ssh zxc-ssh

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

c1-ssh: c1-ssh10

asd-ssh: asd-ssh10

kub-ssh: kub-ssh10

zxc-ssh: zxc-ssh10

c1-ssh%:
	@ssh $(SSH_OPTIONS) centos@10.20.2.$* $(BECOME_ROOT)

asd-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.2.$* $(BECOME_ROOT)

kub-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.4.$* $(BECOME_ROOT)

zxc-ssh%:
	@ssh $(SSH_OPTIONS) cloud-user@10.30.2.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/centos/ && make clean
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean

# vim:ts=4:sw=4:noet:syn=make:
