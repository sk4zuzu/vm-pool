
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

.PHONY: any-disk

any-disk:
	cd $(SELF)/packer/any/ && make build

.PHONY: any-apply any-destroy

any-apply: any-disk
	cd $(SELF)/LIVE/any1/ && terragrunt apply $(AUTO_APPROVE)

any-destroy:
	cd $(SELF)/LIVE/any1/ && terragrunt destroy $(AUTO_APPROVE)

.PHONY: asd-apply asd-destroy

asd-apply: any-disk
	cd $(SELF)/LIVE/asd1/ && terragrunt apply $(AUTO_APPROVE)

asd-destroy:
	cd $(SELF)/LIVE/asd1/ && terragrunt destroy $(AUTO_APPROVE)

.PHONY: become ssh-any ssh-asd

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

ssh-any: ssh-any10

ssh-asd: ssh-asd10

ssh-any%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.1.$* $(BECOME_ROOT)

ssh-asd%:
	@ssh $(SSH_OPTIONS) ubuntu@10.20.2.$* $(BECOME_ROOT)

.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/any/ && make clean

# vim:ts=4:sw=4:noet:syn=make:
