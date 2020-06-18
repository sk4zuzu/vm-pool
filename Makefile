
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


.PHONY: ubu-disk kub-disk rhe-disk

ubu-disk:
	cd $(SELF)/packer/ubu/ && make build

kub-disk:
	cd $(SELF)/packer/kub/ && make build

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


.PHONY: asd2-init asd2-apply asd2-destroy

asd2-init:
	cd $(SELF)/LIVE/asd2/ && terragrunt init

asd2-apply: asd2-init ubu-disk
	cd $(SELF)/LIVE/asd2/ && terragrunt apply $(AUTO_APPROVE)

asd2-destroy: asd2-init
	-make -f Makefile.SNAPSHOT clean-x2
	cd $(SELF)/LIVE/asd2/ && terragrunt destroy $(AUTO_APPROVE)


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


.PHONY: asd-backup asd-restore

asd-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-x1

asd-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-x1


.PHONY: asd2-backup asd2-restore

asd2-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-x2

asd2-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-x2


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


.PHONY: become asd-ssh asd2-ssh kub-ssh zxc-ssh

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

asd-ssh: asd-ssh10

asd2-ssh: asd2-ssh10

kub-ssh: kub-ssh10

zxc-ssh: zxc-ssh10

asd-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.2.$* $(BECOME_ROOT)

asd2-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.3.$* $(BECOME_ROOT)

kub-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.4.$* $(BECOME_ROOT)

zxc-ssh%:
	@ssh $(SSH_OPTIONS) cloud-user@10.30.2.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/ubu/ && make clean
	-cd $(SELF)/packer/kub/ && make clean
	-cd $(SELF)/packer/rhe/ && make clean

# vim:ts=4:sw=4:noet:syn=make:
