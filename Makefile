###########################################################################
## Variables
###########################################################################

ifeq ($(shell uname -s),Linux)
	DOTFILES_DIR := $(HOME)/dev/code/dotfiles
else ifeq ($(shell uname -s),Darwin)
	DOTFILES_DIR := $(HOME)/Projects/dotfiles
else
	DOTFILES_DIR := $(HOME)/dotfiles
endif

MAKEFLAGS = --no-print-directory

YELLOW = \033[0;33m
GREEN  = \033[0;32m
RED    = \033[0;31m
NC     = \033[0m

###########################################################################
## Helper Functions
###########################################################################

define pretty_print
    name_length=$$(echo "$(1)" | wc -c); \
    width=$$(expr 30 - $$name_length); \
    dots=$$(printf '%*s' $$width | tr ' ' '.'); \
    printf " %s %s %b\n" "$(1)" "$$dots" $(2)
endef

define do_target_git
    $(call pretty_print, $(1), "$(YELLOW)"FORCED"$(NC)"); \
    rm -rf $(HOME)/$(2)
    git clone --depth=1 $(3) $(HOME)/$(2) >/dev/null 2>&1
endef

define do_target
	if diff -q $(HOME)/$(2) $(DOTFILES_DIR)/$(3) >/dev/null 2>&1; then \
		$(call pretty_print, $(1), "$(GREEN)"OK"$(NC)"); \
	else \
		$(call pretty_print, $(1), "$(YELLOW)"UPDATED"$(NC)"); \
		rm -rf $(HOME)/$(2); \
    	ln -s $(DOTFILES_DIR)/$(3) $(HOME)/$(2); \
	fi
endef

###########################################################################
## Package Management
###########################################################################

.PHONY: pretty_header
pretty_header: 
	@ $(call pretty_print, $(if $(CALLER),$(CALLER),$@))

.PHONY: update_submodule 
update_submodule:
	@ git submodule update --remote

.PHONY: i3wm
i3wm:
	@ $(call do_target,$@,.config/i3/config,i3wm/i3/config)
	@ $(call do_target,'i3status',.config/i3status/config,i3wm/i3status/config)

.PHONY: bspwm
bspwm: polybar
	@ $(call do_target,$@,.config/bspwm/bspwmrc,bspwm/bspwmrc)
	@ $(call do_target,'sxhkd',.config/sxhkd/sxhkdrc,sxhkd/sxhkdrc)

.PHONY: polybar
polybar:
	@ $(call do_target,$@,.config/polybar/config.ini,config.ini)
	@ $(call do_target,$@,.config/polybar/launch.sh,polybar/launch.sh)

.PHONY: xterm
xterm: 
	@ $(call do_target,$@,.Xresources,xterm/.Xresources)

.PHONY: ghostty
ghostty: 
	@ $(call do_target,$@,.config/ghostty/config,ghostty/config)

.PHONY: vim
vim: 
	@ $(call do_target,$@,.vimrc,vim/.vimrc)

.PHONY: zsh
zsh: zsh_plugins
	@ $(call do_target,$@,.zshrc,zsh/.zshrc)
	
.PHONY: zsh_plugins
zsh_plugins: 
	@ $(call do_target_git,$@,.oh-my-zsh/plugins/zsh-syntax-highlighting,https://github.com/zsh-users/zsh-syntax-highlighting)

.PHONY: bash
bash: 
	@ $(call do_target,$@,.bash_profile_linux,bash/.bash_profile_linux)

.PHONY: tmux
tmux: 
	@ $(call do_target,$@,.tmux.conf,tmux/.tmux.conf)

.PHONY: emacs 
emacs: 
	@ $(call do_target_git,$@,.emacs.d,https://github.com/RaphaeleL/.emacs.d)

.PHONY: nvim
nvim: 
	@ $(call do_target_git,$@,.config/nvim,https://github.com/RaphaeleL/nvim)

###########################################################################
## Installations of Dependencies depending on the OS
###########################################################################

.PHONY: install_fedora
install_fedora:
	@ $(call pretty_print, "dependencies", "$(YELLOW)"INSTALLED"$(NC)")
	@ # TODO: Ghostty
	@ # TODO: Dynamic Package Manager Selection (pacman, apt, ...) 
	@ dnf install zsh tmux i3 zig git >/dev/null
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: install_mac
install_mac:
	@ $(call pretty_print, "dependencies", "$(YELLOW)"INSTALLED"$(NC)")
	@ # TODO: Ghostty
	@ # TODO: Homebrew 
	@ brew install --quiet zsh tmux zig git >/dev/null
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

###########################################################################
## Operating System
###########################################################################

.PHONY: linux
linux: install_fedora
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) i3wm 
	@ $(MAKE) ghostty
	@ $(MAKE) vim

.PHONY: mac
mac: install_mac
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux 
	@ $(MAKE) zsh 
	@ $(MAKE) ghostty
	@ $(MAKE) vim
