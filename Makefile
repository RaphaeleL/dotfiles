.PHONY: linux mac windows

MAKEFLAGS = --no-print-directory

i3wm:
	@ echo '***** i3wm'
	@ cp -R i3wm/i3/config ~/.config/i3/config
	@ cp -R i3wm/i3status/config ~/.config/i3status/config

xterm: 
	@ echo '***** xterm'
	@ cp -R xterm/.Xresources ~/.Xresources

ghostty: 
	@ echo '***** ghostty'
	@ cp -R ghostty/config ~/.config/ghostty/config

vim: 
	@ echo '***** vim'
	@ cp -R vim/.vimrc ~/.vimrc

zsh: 
	@ echo '***** zsh'
	@ cp -R zsh/.zshrc ~/.zshrc

bash: 
	@ echo '***** bash'
	@ cp -R bash/.bash_profile_linux ~/.bash_profile

tmux: 
	@ echo '***** tmux'
	@ cp -R tmux/.tmux.conf ~/.tmux.conf

nvim: 
	@ echo '***** nvim'
	@ cp -R nvim/ ~/.config/nvim

linux: 
	@ echo '********** LINUX'
	@ $(MAKE) nvim
	@ $(MAKE) tmux 
	@ $(MAKE) bash 
	@ $(MAKE) zsh 
	@ $(MAKE) i3wm 
	@ $(MAKE) xterm
	@ $(MAKE) ghostty

mac:
	@ echo '********** MACOS'
	@ $(MAKE) nvim
	@ $(MAKE) tmux 
	@ $(MAKE) bash 
	@ $(MAKE) zsh 
	@ $(MAKE) ghostty

windows:
	@ echo '********** WINDOWS'
	@ echo '***** makefile is not implemented for windows yet'

clean:
	@ echo '********** CLEAN'
	@ echo '***** tmux' && rm -rf ~/.tmux.conf
	@ echo '***** nvim' && rm -rf ~/.config/nvim
	@ echo '***** bash' && rm -rf ~/.bash_profile
	@ echo '***** ssh' && rm -rf ~/.zshrc
	@ echo '***** i3wm' && rm -rf ~/.config/i3/config && rm -rf ~/.config/i3status/config
	@ echo '***** xterm' && rm -rf ~/.Xresources
	@ echo '***** ghostty' && rm -rf ~/.config/ghostty/config

