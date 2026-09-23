.PHONY: update
update:
	git add .
	sudo nixos-rebuild switch --flake ~/nixos/#mrjw
.PHONY: clean
clean:
	nix-collect-garbage --delete-older-than 2d
	sudo nix-collect-garbage --delete-older-than 2d
