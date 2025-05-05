MAKEFLAGS = --no-print-directory
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	DOTFILES_DIR := $(HOME)/dev/code/dotfiles
else ifeq ($(UNAME_S),Darwin)
	DOTFILES_DIR := $(HOME)/Projects/dotfiles
else
	DOTFILES_DIR := $(HOME)/dotfiles
endif

.PHONY: update_submodule 
update_submodule:
	@ git submodule update --remote

.PHONY: i3wm
i3wm:
	@ echo '***** i3wm'
	@ rm -rf ~/.config/i3 ~/.config/i3status
	@ mkdir -p ~/.config/i3 ~/.config/i3status
	@ ln -s $(DOTFILES_DIR)/i3wm/i3/config ~/.config/i3/config
	@ ln -s $(DOTFILES_DIR)/i3wm/i3status/config ~/.config/i3status/config

.PHONY: bspwm
bspwm:
	@ echo '***** bspwm'
	@ rm -rf ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ ln -s $(DOTFILES_DIR)bspwm/bspwmrc ~/.config/bspwm/bspwmrc
	@ ln -s $(DOTFILES_DIR)/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
	@ ln -s $(DOTFILES_DIR)/polybar/config.ini ~/.config/polybar/config.ini
	@ ln -s $(DOTFILES_DIR)/polybar/launch.sh ~/.config/polybar/launch.sh

.PHONY: xterm
xterm: 
	@ echo '***** xterm'
	@ ln -s $(DOTFILES_DIR)/xterm/.Xresources ~/.Xresources

.PHONY: ghostty
ghostty: 
	@ echo '***** ghostty'
	@ rm -rf ~/.config/ghostty
	@ mkdir -p ~/.config/ghostty
	@ ln -s $(DOTFILES_DIR)/ghostty/config ~/.config/ghostty/config

.PHONY: vim
vim: 
	@ echo '***** vim'
	@ rm -rf ~/.vimrc
	@ ln -s $(DOTFILES_DIR)/vim/.vimrc ~/.vimrc

.PHONY: zsh
zsh: 
	@ echo '***** zsh'
	@ rm -rf ~/.zshrc ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
	@ git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
	@ ln -s $(DOTFILES_DIR)/zsh/.zshrc ~/.zshrc

.PHONY: bash
bash: 
	@ echo '***** bash'
	@ rm -rf ~/.bash_profile
	@ ln -s $(DOTFILES_DIR)/bash/.bash_profile_linux ~/.bash_profile

.PHONY: tmux
tmux: 
	@ echo '***** tmux'
	@ rm -rf ~/.tmux.conf
	@ ln -s $(DOTFILES_DIR)/tmux/.tmux.conf ~/.tmux.conf

.PHONY: emacs 
emacs: 
	@echo '***** emacs'
	@rm -rf ~/.emacs.d/
	@git clone --depth=1 https://github.com/RaphaeleL/.emacs.d ~/.emacs.d >/dev/null 2>&1

.PHONY: nvim
nvim: 
	@echo '***** nvim'
	@rm -rf ~/.config/nvim
	@rm -rf ~/.local/share/nvim
	@rm -rf ~/.local/state/nvim
	@git clone --depth=1 https://github.com/RaphaeleL/nvim ~/.config/nvim >/dev/null 2>&1

.PHONY: header_linux
header_linux:
	@ echo '********** LINUX'

.PHONY: header_mac
header_mac:
	@ echo '********** MACOS'

.PHONY: header_windows
header_window:
	@ echo '********** WINDOWS'

.PHONY: install_fedora
install_fedora:
	@echo '***** install'
	@ # TODO: Ghostty
	@ # TODO: Dynamic Package Manager Selection (pacman, apt, ...) 
	@ dnf install zsh tmux i3 zig git >/dev/null
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: install_mac
install_mac:
	@echo '***** install'
	@ # TODO: Ghostty
	@ # TODO: Homebrew 
	@ brew install --quiet zsh tmux zig git
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: install_windows
install_windows:
	@echo '***** install'
	@ # TODO: all

.PHONY: linux
linux: header_linux install_fedora
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) i3wm 
	@ $(MAKE) ghostty
	@ $(MAKE) vim

.PHONY: mac
mac: header_mac install_mac
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) ghostty
	@ $(MAKE) vim

.PHONY: windows
windows: header_windows install_windows
	@ echo '********** WINDOWS'
	@ echo '***** TODO'
	@ # TODO: all
