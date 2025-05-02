MAKEFLAGS = --no-print-directory

.PHONY: i3wm
i3wm:
	@ echo '***** i3wm'
	@ rm -rf ~/.config/i3 ~/.config/i3status
	@ mkdir -p ~/.config/i3 ~/.config/i3status
	@ ln -s $(HOME)/dev/code/dotfiles/i3wm/i3/config ~/.config/i3/config
	@ ln -s $(HOME)/dev/code/dotfiles/i3wm/i3status/config ~/.config/i3status/config

.PHONY: bspwm
bspwm:
	@ echo '***** bspwm'
	@ rm -rf ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ ln -s $(HOME)/dev/code/dotfiles/bspwm/bspwmrc ~/.config/bspwm/bspwmrc
	@ ln -s $(HOME)/dev/code/dotfiles/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
	@ ln -s $(HOME)/dev/code/dotfiles/polybar/config.ini ~/.config/polybar/config.ini
	@ ln -s $(HOME)/dev/code/dotfiles/polybar/launch.sh ~/.config/polybar/launch.sh

.PHONY: xterm
xterm: 
	@ echo '***** xterm'
	@ ln -s $(HOME)/dev/code/dotfiles/xterm/.Xresources ~/.Xresources

.PHONY: ghostty
ghostty: 
	@ echo '***** ghostty'
	@ rm -rf ~/.config/ghostty
	@ mkdir -p ~/.config/ghostty
	@ ln -s $(HOME)/dev/code/dotfiles/ghostty/config ~/.config/ghostty/config

.PHONY: vim
vim: 
	@ echo '***** vim'
	rm -rf ~/.vimrc
	@ ln -s $(HOME)/dev/code/dotfiles/vim/.vimrc ~/.vimrc

.PHONY: zsh
zsh: 
	@ echo '***** zsh'
	@ rm -rf ~/.zshrc ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
	@ git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
	@ ln -s $(HOME)/dev/code/dotfiles/zsh/.zshrc ~/.zshrc

.PHONY: bash
bash: 
	@ echo '***** bash'
	@ rm -rf ~/.bash_profile
	@ ln -s $(HOME)/dev/code/dotfiles/bash/.bash_profile_linux ~/.bash_profile

.PHONY: tmux
tmux: 
	@ echo '***** tmux'
	@ rm -rf ~/.tmux.conf
	@ ln -s $(HOME)/dev/code/dotfiles/tmux/.tmux.conf ~/.tmux.conf

.PHONY: emacs 
emacs: 
	@echo '***** emacs'
	@rm -rf ~/.emacs.d/
	@git clone https://github.com/RaphaeleL/.emacs.d ~/.emacs.d >/dev/null 2>&1

.PHONY: nvim
nvim: 
	@echo '***** nvim'
	@rm -rf ~/.config/nvim
	@git clone https://github.com/RaphaeleL/nvim ~/.config/nvim >/dev/null 2>&1

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
	@ dnf install zsh tmux i3 zig git >/dev/null 2>&1
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: install_mac
install_mac:
	@echo '***** install'
	@ # TODO: Ghostty
	@ # TODO: Homebrew 
	@ brew install zsh tmux zig git
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

.PHONY: mac
mac: header_mac install_mac
	@ echo '********** MACOS'
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) ghostty

.PHONY: windows
windows: header_windows install_windows
	@ echo '********** WINDOWS'
	@ echo '***** TODO'
