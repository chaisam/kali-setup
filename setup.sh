#!/usr/bin/env bash

#script to run on new kali machines to deploy programs and dotfiles
#TODO link from current dir or ~/.dotfiles based on user input.
#If using it on main machine should link from current dir to sync changes 

# Get the absolute path of the script's directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
VIM_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
TPM="https://github.com/tmux-plugins/tpm"
VIM_NIGHTLY="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
FZF_TAB="https://github.com/Aloxaf/fzf-tab"
DOOM="https://github.com/doomemacs/doomemacs"

#sudo cache
echo "Please enter your password for sudo access (it will be cached for a few minutes):"
sudo -v

# check if the sudo credentials are still valid before proceeding with commands that require sudo
if sudo -n true 2>/dev/null; then
  echo "Sudo access is valid. Continuing with the script..."
else
  echo "Sudo access has expired or the password was incorrect. Exiting the script."
  exit 1
fi

#disable password for sudo
echo "Disable being prompt for password when using sudo? (Y/N)"
read answer

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
	echo "using /etc/sudoers.d/$USER to create rule"
	sudo sh -c 'echo "$(logname) ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$(logname)'
	sudo chmod 440 /etc/sudoers.d/$(logname)
else
    echo "Not making any change"
fi

#installing programs
echo "Do you want to install base programs(neovim/emacs/xclip/tmux etc..)? (Y/N)"
read answer

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
	echo "updating repo"
	sudo apt update -y
	echo "will install base programs"
	sudo apt install -y kitty neovim emacs xclip tmux fzf bat git
	echo "cloning oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sleep 5
	echo "cloning doom emacs"
	git clone --depth 1 $DOOM ~/.config/emacs
	~/.config/emacs/bin/doom install
	rm -rf ~/.emacs.d
	echo "cloning tpm plugin for tmux"
	mkdir -p $HOME/.config/tmux/plugins/tpm
	git clone $TPM ~/.config/tmux/plugins/tpm/
	echo "creating $HOME/bin dir and downloading nvim nightly"
	mkdir $HOME/bin
	wget $VIM_NIGHTLY -P $HOME/bin/
	mv $HOME/bin/nvim.appimage $HOME/bin/nvim
	chmod +x $HOME/bin/nvim
	echo "cloning fzf-tab"
	git clone $FZF_TAB ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

	sudo apt install -y fonts-hack fonts-powerline libtool libvterm libvterm-dev libtool-bin pkg-config libssl-dev 

	mkdir -p ~/.local/share/nvim/site/autoload
	wget $VIM_PLUG -P ~/.local/share/nvim/site/autoload/

	#linking dotfiles
	echo "linking dotfiles"
	#TODO should add a choice if to link or copy
	ln -sf $SCRIPT_DIR/dotfiles/config/doom ~/.config/
	ln -sf $SCRIPT_DIR/dotfiles/config/i3 ~/.config/
	ln -sf $SCRIPT_DIR/dotfiles/config/kitty ~/.config/
	ln -sf $SCRIPT_DIR/dotfiles/config/nvim ~/.config/
	ln -sf $SCRIPT_DIR/dotfiles/config/rofi ~/.config/
	rm -rf ~/.config/tmux
	ln -sf $SCRIPT_DIR/dotfiles/config/tmux ~/.config/
	ln -sf $SCRIPT_DIR/dotfiles/wallpapers ~/.wallpapers
	ln -sf $SCRIPT_DIR/dotfiles/config/zshrc ~/.zshrc

else
    echo "skipping installing base programs."
fi


echo "Do you want to install xtra programs & tiling desktop(keepassxc, flameshot, i3, rofi etc..)? (Y/N)"
read answer

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
	echo "Installing extra utilities"
	sudo apt install -y keepassxc flameshot rofi i3 feh
	sleep 3
	sudo apt install -y build-essential cmake vim-nox python3-dev 
	sleep 3
	sudo apt install -y mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
	sleep 3
	echo "run nvim; use PlugInstall; exit and run python ~/.vim/bundle/YouCompleteMe/install.py"
	
else
    echo "skipping instaling xtra programs."
fi


exit 0
