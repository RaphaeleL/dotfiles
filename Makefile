###########################################################################
## Variables
###########################################################################

OS = $(shell uname -s)
DISTRO = $(shell . /etc/os-release 2> /dev/null && echo $$ID)
MAKEFLAGS = --no-print-directory

ifeq ($(OS),Linux)
	DOTFILES_DIR := $(HOME)/dev/code/dotfiles
else ifeq ($(OS),Darwin)
	DOTFILES_DIR := $(HOME)/Projects/dotfiles
else
	DOTFILES_DIR := $(HOME)/dotfiles
endif

YELLOW = \033[0;33m
GREEN  = \033[0;32m
RED	   = \033[0;31m
NC	   = \033[0m

###########################################################################
## Helper Functions
###########################################################################

PLATFORM := $(shell \
	if [ "$(OS)" = "Linux" ] && [ "$(DISTRO)" = "fedora" ]; then echo "fedora"; \
	elif [ "$(OS)" = "Darwin" ]; then echo "mac"; \
	else echo "unsupported"; fi \
)

.PHONY: check_dotfiles
check_dotfiles:
	@if [ ! -d "$(DOTFILES_DIR)" ]; then \
		echo "[ERROR] dotfiles directory not found: $(DOTFILES_DIR)"; \
		exit 1; \
	fi

define pretty_print
	name_length=$$(echo "$(1)" | wc -c); \
	width=$$(expr 30 - $$name_length); \
	dots=$$(printf '%*s' $$width | tr ' ' '.'); \
	printf " %s %s %b\n" "$(1)" "$$dots" $(2)
endef

define do_target_git
	@ $(MAKE) check_dotfiles
	if [ -d "$(HOME)/$(2)/.git" ]; then \
		$(call pretty_print, $(1), "$(YELLOW)UPDATING$(NC)"); \
		cd "$(HOME)/$(2)" && git pull --quiet >/dev/null 2>&1 || { printf "$(RED)Failed to update $(2)$(NC)\n"; exit 128; }; \
	elif [ -d "$(HOME)/$(2)" ]; then \
		$(call pretty_print, $(1), "$(YELLOW)REMOVING NON-GIT DIR$(NC)"); \
		rm -rf "$(HOME)/$(2)"; \
		$(call pretty_print, $(1), "$(YELLOW)CLONING$(NC)"); \
		mkdir -p $$(dirname "$(HOME)/$(2)"); \
		git clone --depth=1 $(4) "$(HOME)/$(2)" >/dev/null 2>&1 || { printf "$(RED)Clone failed for $(4)$(NC)\n"; exit 128; }; \
	else \
		$(call pretty_print, $(1), "$(YELLOW)CLONING$(NC)"); \
		mkdir -p $$(dirname "$(HOME)/$(2)"); \
		git clone --depth=1 $(4) "$(HOME)/$(2)" >/dev/null 2>&1 || { printf "$(RED)Clone failed for $(4)$(NC)\n"; exit 128; }; \
	fi
endef

define check_target
	@ $(MAKE) check_dotfiles
	if [ -L $(HOME)/$(2) ]; then \
		if [ "$$(readlink -f $(HOME)/$(2))" = "$$(realpath $(DOTFILES_DIR)/$(3))" ]; then \
			$(call pretty_print, $(1), "$(GREEN)LINK$(NC)"); \
		else \
			$(call pretty_print, $(1), "$(RED)WRONG LINK$(NC)"); \
		fi; \
	elif [ -e $(HOME)/$(2) ]; then \
		$(call pretty_print, $(1), "$(YELLOW)GIT$(NC)"); \
	else \
		$(call pretty_print, $(1), "$(RED)MISSING$(NC)"); \
	fi
endef

define do_target
	@ $(MAKE) check_dotfiles
	if [ -L $(HOME)/$(2) ] && [ "$$(readlink -f $(HOME)/$(2))" = "$$(realpath $(DOTFILES_DIR)/$(3))" ]; then \
		$(call pretty_print, $(1), "$(GREEN)"OK"$(NC)"); \
	elif [ -e $(HOME)/$(2) ] || [ -L $(HOME)/$(2) ]; then \
		$(call pretty_print, $(1), "$(YELLOW)"UPDATED"$(NC)"); \
		rm -rf $(HOME)/$(2); \
		mkdir -p $$(dirname $(HOME)/$(2)); \
		ln -s $(DOTFILES_DIR)/$(3) $(HOME)/$(2); \
	else \
		$(call pretty_print, $(1), "$(YELLOW)"MISSING"$(NC)"); \
		mkdir -p $$(dirname $(HOME)/$(2)); \
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
	@ $(call do_target,$@ status,.config/i3status/config,i3wm/i3status/config)

.PHONY: bspwm
bspwm: polybar
	@ $(call do_target,$@,.config/bspwm/bspwmrc,bspwm/bspwmrc)
	@ $(call do_target,sxhkd,.config/sxhkd/sxhkdrc,sxhkd/sxhkdrc)

.PHONY: polybar
polybar:
	@ $(call do_target,$@,.config/polybar/config.ini,polybar/config.ini)
	@ $(call do_target,$@ launcher,.config/polybar/launch.sh,polybar/launch.sh)

.PHONY: xterm
xterm:
	@ $(call do_target,$@,.Xresources,xterm/.Xresources)

.PHONY: ghostty
ghostty:
ifeq ($(PLATFORM),fedora)
	@$(call do_target,$@,.config/ghostty/config,ghostty/config_linux)
else ifeq ($(PLATFORM),mac)
	@$(call do_target,$@,.config/ghostty/config,ghostty/config_macos)
else
	@echo "unsupported platform"
endif

.PHONY: vim
vim:
	@ $(call do_target,$@,.vimrc,vim/.vimrc)

.PHONY: zsh
zsh:
ifeq ($(PLATFORM),fedora)
	@$(call do_target,$@,.zshrc,zsh/.zshrc)
	@$(call do_target_git,$@,plugins,.oh-my-zsh/plugins/zsh-syntax-highlighting,https://github.com/zsh-users/zsh-syntax-highlighting)
else ifeq ($(PLATFORM),mac)
	@$(call do_target,$@,.zshrc,zsh/.zshrc.mac)
	@$(call do_target_git,$@,plugins,.oh-my-zsh/plugins/zsh-syntax-highlighting,https://github.com/zsh-users/zsh-syntax-highlighting)
else
	@echo "unsupported platform"
endif

.PHONY: bash
bash:
ifeq ($(PLATFORM),fedora)
	@ $(call do_target,$@,.bash_profile,bash/.bash_profile_linux)
else ifeq ($(PLATFORM),mac)
	@ $(call do_target,$@,.bash_profile,bash/.bash_profile)
else
	@echo "unsupported platform"
endif

.PHONY: tmux
tmux:
	@ $(call do_target,$@,.tmux.conf,tmux/.tmux.conf)
	@ $(call do_target,$@,.local/bin/tms,tms/tms)

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
	@ $(call pretty_print, install packages, "$(YELLOW)"DNF"$(NC)")
	@ sudo dnf copr enable pgdev/ghostty -y >/dev/null 2>/dev/null
	@ sudo dnf install zsh tmux i3 bspwm sxhkd zig git lazygit ghostty -y >/dev/null 2>/dev/null
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: install_mac
install_mac:
	@ $(call pretty_print, install packages, "$(YELLOW)"BREW"$(NC)")
	@ # TODO: Homebrew
	@ brew install --quiet --cask ghostty >/dev/null
	@ brew install --quiet zsh tmux zig git lazygit >/dev/null
	@ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

###########################################################################
## Operating System
###########################################################################

.PHONY: fedora
fedora: install_fedora
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux
	@ $(MAKE) zsh
	@ $(MAKE) i3wm
	@ $(MAKE) bspwm
	@ $(MAKE) ghostty
	@ $(MAKE) vim
	@ $(MAKE) xterm

.PHONY: mac
mac: install_mac
	@ $(MAKE) nvim
	@ $(MAKE) emacs
	@ $(MAKE) tmux
	@ $(MAKE) zsh
	@ $(MAKE) ghostty
	@ $(MAKE) vim

###########################################################################
## Wrapper
###########################################################################

.PHONY: help
help:
	@ echo ""
	@ echo "  Available make targets:"
	@ echo ""
	@ echo "  auto ................. Install and setup everything based on the OS"
	@ echo "   fedora ............... - for GNU/Linux Fedora"
	@ echo "   mac .................. - for macOS"
	@ echo ""
	@ echo "  support ............. Check if the OS is supported"
	@ echo "  status .............. Check if everything is in place"
	@ echo "  tools ............... Get the available and supported tools"
	@ echo ""
	@ echo "  update_submodule .... Update git submodules (emacs, nvim)"
	@ echo ""

.PHONY: tools
tools:
	@ echo ""
	@ echo "  Supported Tools:"
	@ echo ""
	@ echo "  i3wm	............. i3 window manager and i3status"
	@ echo "  bspwm ............. BSPWM window manager with sxhkd"
	@ echo "  polybar ........... Polybar status bar"
	@ echo "  xterm ............. XTerm terminal configuration"
	@ echo "  ghostty ........... Ghostty terminal emulator"
	@ echo "  vim ............... Vim configuration"
	@ echo "  zsh ............... Zsh shell configuration"
	@ echo "  bash .............. Bash shell configuration"
	@ echo "  tmux .............. Tmux configuration"
	@ echo "  emacs ............. Emacs configuration"
	@ echo "  nvim .............. Neovim configuration"
	@ echo ""
	@ echo "  Use 'make <tool_name>' to setup or update a specific tool"
	@ echo ""

.PHONY: status
status:
	@ $(call pretty_print, OS, "$(GREEN)$(OS)$(NC)")
	@ $(call check_target,nvim,.config/nvim,unused)
	@ $(call check_target,emacs,.emacs.d,unused)
	@ $(call check_target,tmux,.tmux.conf,tmux/.tmux.conf)
	@ $(call check_target,zsh,.zshrc,zsh/.zshrc.mac)
	@ $(call check_target,zsh plugins,.oh-my-zsh/plugins/,unused)
	@ $(call check_target,vim,.vimrc,vim/.vimrc)
ifeq ($(PLATFORM),fedora)
	@ $(call check_target,xterm,.Xresources,xterm/.Xresources)
	@ $(call check_target,i3wm,.config/i3/config,i3wm/i3/config)
	@ $(call check_target,i3wm status,.config/i3status/config,i3wm/i3status/config)
	@ $(call check_target,polybar,.config/polybar/config.ini,config.ini)
	@ $(call check_target,polybar launcher,.config/polybar/launch.sh,polybar/launch.sh)
	@ $(call check_target,bspwm,.config/bspwm/bspwmrc,bspwm/bspwmrc)
	@ $(call check_target,sxhkd,.config/sxhkd/sxhkdrc,sxhkd/sxhkdrc)
else ifeq ($(PLATFORM),mac)
	@$(call do_target,$@,.config/ghostty/config,ghostty/config_macos)
else
	@ $(call check_target,ghostty,.config/ghostty/config,ghostty/config_macos)
endif

.PHONY: support
support: check_dotfiles
	@ if [ "$(PLATFORM)" = "unsupported" ]; then \
		$(call pretty_print, $(DISTRO) ($(OS)), "$(RED)NO$(NC)"); \
	else \
		$(call pretty_print, $(PLATFORM) ($(OS)), "$(GREEN)YES$(NC)"); \
	fi

.PHONY: auto
auto: check_dotfiles
	@ if [ "$(PLATFORM)" = "fedora" ]; then \
		$(MAKE) fedora; \
	elif [ "$(PLATFORM)" = "mac" ]; then \
		$(MAKE) mac; \
	else \
		echo "Your Platform is not supported yet."; \
	fi
