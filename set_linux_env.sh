#set develpment in linux

# firstly, auto select Distro version,if ubuntu use apt if arch use pacman if fedora use dnf etc;
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
fi

# secondly, auto install some tools for develop
if [ $OS = 'ubuntu' ]; then
    sudo apt update && sudo apt install -y git curl wget vim zsh gcc clang cmake make python3 python3-pip
elif [ $OS = 'debian' ]; then
    sudo apt update && sudo apt install -y git curl wget vim zsh gcc clang cmake make python3 python3-pip
elif [ $OS = 'arch' ]; then
    sudo pacman -Syy && sudo pacman -S git curl wget vim zsh gcc clang cmake make python python-pip
elif [ $OS = 'fedora' ]; then
    sudo dnf update && sudo dnf install -y git curl wget vim zsh gcc clang cmake make python3 python3-pip
else
    echo "Unsupported Distro"
fi
# Set zsh as the default shell
chsh -s $(which zsh)

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Enable the plugins in .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Set the theme to random in .zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="random"/' ~/.zshrc

# Source .zshrc to take effect
source ~/.zshrc

# Check if zsh is installed
if command -v zsh &> /dev/null
then
    echo "zsh is installed, proceeding with setup."
else
    echo "zsh is not installed. Please install zsh first."
    exit 1
fi

# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is not installed. Please install oh-my-zsh first."
    exit 1
fi

# Check if zsh-autosuggestions is installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is not installed. Please install zsh-autosuggestions first."
    exit 1
fi

# Check if zsh-syntax-highlighting is installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting is not installed. Please install zsh-syntax-highlighting first."
    exit 1
fi

echo "All necessary components are installed. You're good to go!"


#Then set git and ssh, git username set "rickliu" email set "wikiliu66@outlook.com",config ssh and key 
# open github add ssh key web and message user to fill new key
# Set git username and email
git config --global user.name "rickliu"
git config --global user.email "wikiliu66@outlook.com"

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "wikiliu66@outlook.com"

# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Add your SSH private key to the ssh-agent
ssh-add ~/.ssh/id_rsa

# Install xclip to access clipboard
if [ $OS = 'ubuntu' ] || [ $OS = 'debian' ]; then
    sudo apt-get install xclip
elif [ $OS = 'arch' ]; then
    sudo pacman -S xclip
elif [ $OS = 'fedora' ]; then
    sudo dnf install xclip
fi

# Copy the SSH key to your clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub

echo "Your new SSH key has been copied to your clipboard. Please add it to your GitHub account."
# Open GitHub user settings in browser
xdg-open "https://github.com/settings/keys"

# Install neovim
if [ $OS = 'ubuntu' ] || [ $OS = 'debian' ]; then
    sudo apt-get install neovim
    sudo apt-get install software-properties-common
    sudo apt-get install python-software-properties
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
elif [ $OS = 'arch' ]; then
    sudo pacman -S neovim
elif [ $OS = 'fedora' ]; then
    sudo dnf install -y neovim python3-neovim
fi
# Check if the directories exist and remove them before cloning
if [ -d "~/.config/nvim" ]; then
    rm -rf ~/.config/nvim
fi

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
git clone https://github.com/WikiLiu/LazyVim_Config.git ~/.config/nvim

# Install tmux
if [ $OS = 'ubuntu' ] || [ $OS = 'debian' ]; then
    sudo apt-get install tmux
elif [ $OS = 'arch' ]; then
    sudo pacman -S tmux
elif [ $OS = 'fedora' ]; then
    sudo dnf install tmux
fi

# Install tmux plugin manager
if [ ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "tmux plugin manager is already installed."
fi

echo 'set -g default-terminal "screen-256color"
set -g @plugin "tmux-plugins/tpm"
set -g @plugin "tmux-plugins/tmux-sensible"

# 插件列表开始
set -g @plugin "tmux-plugins/tmux-resurrect"
set -g @plugin "tmux-plugins/tmux-continuum"
# 插件列表结束

# 初始化 TPM（不要删除这一行）
run "~/.tmux/plugins/tpm/tpm"

# set vi-mode
setw -g mode-keys vi
# keybindings
#bind-key -T copy-mode-vi v send-keys -X begin-selection
#bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle \; send -X begin-selection
#bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
## comment the preceding line and uncomment the following to yank to X clipboard
## bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
## 绑定hjkl键为面板切换的上下左右键
#bind -r k select-pane -U # 绑定k为↑
#bind -r j select-pane -D # 绑定j为↓
#bind -r h select-pane -L # 绑定h为←
#bind -r l select-pane -R # 绑定l为→

set-option -g renumber-windows on
set -g  mouse on
#source /usr/share/powerline/bindings/tmux/powerline.conf
# 设置 tmux-powerline 状态栏
#source-file ~/tmux-powerline/tmux-powerline.conf

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1


set -g default-terminal "tmux-256color"
set -as terminal-overrides ',xterm*:sitm=\E[3m'


run-shell ~/.tmux/plugins/tmux-resurrect/resurrect.tmux"' >> ~/.tmux.conf



