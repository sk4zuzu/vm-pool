
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


.PHONY: ubu-disk rhe-disk

ubu-disk:
	cd $(SELF)/packer/ubu/ && make build

rhe-disk:
	cd $(SELF)/packer/rhe/ && make build


.PHONY: asd-apply asd-destroy

asd-apply: ubu-disk
	cd $(SELF)/LIVE/asd1/ && terragrunt apply $(AUTO_APPROVE)

asd-destroy:
	-make -f Makefile.SNAPSHOT clean-x1
	cd $(SELF)/LIVE/asd1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: zxc-apply zxc-destroy

zxc-apply: rhe-disk
	cd $(SELF)/LIVE/zxc1/ && terragrunt apply $(AUTO_APPROVE)

zxc-destroy:
	-make -f Makefile.SNAPSHOT clean-y1
	cd $(SELF)/LIVE/zxc1/ && terragrunt destroy $(AUTO_APPROVE)


.PHONY: asd-backup asd-restore

asd-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-x1

asd-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-x1


.PHONY: zxc-backup zxc-restore

zxc-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-y1

zxc-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-y1


.PHONY: become ssh-asd ssh-zxc

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

ssh-asd: ssh-asd10

ssh-zxc: ssh-zxc10

ssh-asd%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.2.$* $(BECOME_ROOT)

ssh-zxc%:
	@ssh $(SSH_OPTIONS) cloud-user@10.20.3.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/ubu/ && make clean
	-cd $(SELF)/packer/rhe/ && make clean

# vim:ts=4:sw=4:noet:syn=make:
