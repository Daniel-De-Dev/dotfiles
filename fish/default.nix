{ pkgs, ... }:
{
  packages = with pkgs; [
    fish
    starship
    eza
    bat
    zoxide
    fzf
    fishPlugins.fzf-fish
    fd
    ripgrep
    tldr
    # TODO: Uncomment once configs have been updated to new system
    # neovim
    # git
  ];
  variables = {};
  assertions = [];
  warnings = [];
}
