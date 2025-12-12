{ pkgs, config, ... }:
{
  packages = with pkgs; [
    kitty
  ];
  variables = {};
  assertions = [];
  warnings = if ! (builtins.elem pkgs.nerd-fonts.jetbrains-mono config.fonts.packages) then [
      ''
        Kitty config uses 'JetBrainsMono Nerd Font', but package '${pkgs.nerd-fonts.jetbrains-mono.name}' is not in 'fonts.packages'.
        Please add 'pkgs.nerd-fonts.jetbrains-mono' to 'fonts.packages' in your NixOS configuration.
      ''
    ] else [];
}
