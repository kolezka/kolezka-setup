.PHONY: install update lint

install:
	./install.sh

update:
	git pull --rebase
	./install.sh

lint:
	shellcheck install.sh
	shellcheck .zshrc || true
