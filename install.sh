echo "+======================================+"
echo "|                                      |"
echo "| Installing Homebrew                  |"
echo "|                                      |"
echo "+======================================+"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "+======================================+"
echo "|                                      |"
echo "| Installing Brew Packages             |"
echo "|                                      |"
echo "+======================================+"

brew bundle --file=brewfile

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: Tmux                       |"
echo "|                                      |"
echo "+======================================+"
cp tmux/.tmux.conf ~/

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: Vim                        |"
echo "|                                      |"
echo "+======================================+"
cp vim/.vimrc ~/

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: Zsh                        |"
echo "|                                      |"
echo "+======================================+"
cp zsh/.zshrc ~/
cp zsh/own-theme.zsh-theme ~/.oh-my-zsh/custom/theme

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: Kitty                      |"
echo "|                                      |"
echo "+======================================+"
mkdir ~/config/kitty
cp kitty/kitty.conf ~/config/kitty

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: Alacritty                  |"
echo "|                                      |"
echo "+======================================+"
mkdir ~/config/alacritty
cp alacritty/alacritty.yml ~/config/alacritty

echo "+======================================+"
echo "|                                      |"
echo "| Dotfiles: NeoVim                     |"
echo "|                                      |"
echo "+======================================+"
bash <(curl -s https://raw.githubusercontent.com/RaphaeleL/nvim/main/install.sh)

echo "+======================================+"
echo "|                                      |"
echo "| Settings: TODO                       |"
echo "|                                      |"
echo "+======================================+"
echo " [iTerm2] -> Import and Select 'Kanagawa' as Profile." 
echo " [NeoVim] -> Open Neovim and Type ':PackerInstall'." 
echo " [TouchID] -> Use TouchID for 'sudo' access in the Terminal (for MacOS)." 
