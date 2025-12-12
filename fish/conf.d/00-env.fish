set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-login
    fish_add_path $HOME/.local/bin $HOME/.cargo/bin
end

# TODO: Move to its own config eventually
set -gx STARSHIP_CONFIG $HOME/.config/fish/starship.toml

set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
