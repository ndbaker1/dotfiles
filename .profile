#!/usr/bin/env sh

# ::::::::::::::::::::::::::::::
# POSIX compliant shell setup.
# ::::::::::::::::::::::::::::::

# local shell setup.
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"

# ::: unconditional paths.

# add user's private and local bin paths.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# add golang bin paths.
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# add bun bin path.
export PATH="$PATH:$HOME/.bun/bin"

# add n bin path.
export PATH="$PATH:$HOME/.n/bin"

# ::: conditional paths.

# local environment.
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# configure nix (multi-user, then single-user).
[ -f "/etc/profile.d/nix.sh" ] && . /etc/profile.d/nix.sh
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

# configure cargo.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ::: conditional binaries.

# set default terminal.
command -v alacritty > /dev/null && export TERM=alacritty

# set default editor.
command -v nvim > /dev/null && export EDITOR=nvim

# set default shell.
command -v fish > /dev/null && export SHELL="$(which fish)"

# ::: use a different login shell if interactive.

if [ -n "$SHELL" ]; then
    case "$-" in
        *i*) exec -l "$SHELL" ;;
    esac
fi
