# Config & Dotfiles

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ndbaker1/conf/main/dotfiles)"
```

## Shell
- zsh
- fish

## Binaries
starship - https://github.com/starship/starship
 * install through cargo

exa - https://github.com/ogham/exa
 * install through cargo

neovim - https://github.com/neovim/neovim

vim-plug - https://github.com/junegunn/vim-plug
```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

youtube-dl - install pip version

tmux config - https://github.com/gpakosz/.tmux

