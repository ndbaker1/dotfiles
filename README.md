# Config & Dotfiles

## Install
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ndbaker1/dotfiles/main/.local/bin/dot)"
```

## Commons
- [`starship`](https://github.com/starship/starship)
- [`exa`](https://github.com/ogham/exa)
- [`neovim`](https://github.com/neovim/neovim)

vim-plug - https://github.com/junegunn/vim-plug
```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

