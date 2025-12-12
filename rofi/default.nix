{ pkgs, config, ... }:
{
  packages = with pkgs; [
    rofi
    papirus-icon-theme
  ];
  variables = {};
  assertions = [];
  warnings = if
    !(builtins.elem pkgs.nerd-fonts.jetbrains-mono config.fonts.packages) then [
    ''
      Rofi config uses 'JetBrainsMono Nerd Font', but package '${pkgs.nerd-fonts.jetbrains-mono.name}' is not in 'fonts.packages'.
      Icons and text may not render correctly!
      Please add 'pkgs.nerd-fonts.jetbrains-mono' to 'fonts.packages' in your NixOS configuration.
    '' ] else [];
}
