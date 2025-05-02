.PHONY: linux mac windows

MAKEFLAGS = --no-print-directory

i3wm:
	@ echo '***** i3wm'
	@ rm -rf ~/.config/i3 ~/.config/i3status
	@ mkdir -p ~/.config/i3 ~/.config/i3status
	@ ln -s $(HOME)/dev/code/dotfiles/i3wm/i3/config ~/.config/i3/config
	@ ln -s $(HOME)/dev/code/dotfiles/i3wm/i3status/config ~/.config/i3status/config

bspwm:
	@ echo '***** bspwm'
	@ rm -rf ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar
	@ ln -s $(HOME)/dev/code/dotfiles/bspwm/bspwmrc ~/.config/bspwm/bspwmrc
	@ ln -s $(HOME)/dev/code/dotfiles/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
	@ ln -s $(HOME)/dev/code/dotfiles/polybar/config.ini ~/.config/polybar/config.ini
	@ ln -s $(HOME)/dev/code/dotfiles/polybar/launch.sh ~/.config/polybar/launch.sh

xterm: 
	@ echo '***** xterm'
	@ ln -s $(HOME)/dev/code/dotfiles/xterm/.Xresources ~/.Xresources

ghostty: 
	@ echo '***** ghostty'
	@ rm -rf ~/.config/ghostty
	@ mkdir -p ~/.config/ghostty
	@ ln -s $(HOME)/dev/code/dotfiles/ghostty/config ~/.config/ghostty/config

vim: 
	@ echo '***** vim'
	rm -rf ~/.vimrc
	@ ln -s $(HOME)/dev/code/dotfiles/vim/.vimrc ~/.vimrc

zsh: 
	@ echo '***** zsh'
	@ rm -rf ~/.zshrc ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
	@ git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
	@ ln -s $(HOME)/dev/code/dotfiles/zsh/.zshrc ~/.zshrc

bash: 
	@ echo '***** bash'
	@ rm -rf ~/.bash_profile
	@ ln -s $(HOME)/dev/code/dotfiles/bash/.bash_profile_linux ~/.bash_profile

tmux: 
	@ echo '***** tmux'
	@ rm -rf ~/.tmux.conf
	@ ln -s $(HOME)/dev/code/dotfiles/tmux/.tmux.conf ~/.tmux.conf

nvim: 
	@echo '***** nvim'
	@rm -rf ~/.config/nvim
	@git clone https://github.com/RaphaeleL/nvim ~/.config/nvim >/dev/null 2>&1

header_linux:
	@ echo '********** LINUX'

header_mac:
	@ echo '********** MACOS'

header_window:
	@ echo '********** WINDOWS'

install_fedora:
	@echo '***** install'
	@ dnf install zsh tmux bspwm sxhkd zig >/dev/null 2>&1
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

install_mac:
	@echo '***** install'
	@ brew install zsh tmux bspwm sxhkd zig
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

install_windows:
	@ # TODO
	@echo '***** install'

linux: header_linux install_fedora
	@ $(MAKE) nvim
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) bspwm 
	@ $(MAKE) ghostty

mac: header_mac install_mac
	@ echo '********** MACOS'
	@ $(MAKE) nvim
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) ghostty

windows: header_windows install_windows
	@ echo '********** WINDOWS'
	@ echo '***** TODO'
