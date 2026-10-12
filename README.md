# dotfiles

## 🚀 bootstrap
```sh
curl -fsSL https://raw.githubusercontent.com/ndbaker1/dotfiles/main/.local/bin/dot | sh -s --
```

## 💥 tooling

```sh
# remote
nix profile add "github:ndbaker1/dotfiles?dir=.config/nix-profile"
# local
nix profile add .config/nix-profile
```
