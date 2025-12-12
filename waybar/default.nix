{ pkgs, config, lib, ... }:

let
  requiredFonts = [
    pkgs.font-awesome
    pkgs.fira-sans
  ];
in
{
  packages = with pkgs; [
    waybar
    rofi
    wlogout
    pavucontrol
    blueman
    networkmanagerapplet
    libnotify
    nautilus
    htop
    kitty
    brave
  ];

  variables = {
  };

  assertions = [];
  warnings = lib.concatLists (map (font:
    if ! (builtins.elem font config.fonts.packages) then [
      ''
        Waybar config uses '${font.name}', but it is not in 'fonts.packages'.
        Text or icons might be missing.
        Please add 'pkgs.${font.pname}' to 'fonts.packages' in your NixOS configuration.
      ''
    ] else []
  ) requiredFonts);
}
