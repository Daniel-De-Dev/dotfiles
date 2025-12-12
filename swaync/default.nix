{ pkgs, config, lib, ... }:
let
  requiredFonts = [
    pkgs.fira-sans
    pkgs.font-awesome
  ];
in
{
  packages = with pkgs; [
    swaynotificationcenter
    hyprlock
    networkmanager
    pulseaudio
    libnotify
    util-linux
    gnugrep
  ];

  variables = {
    DEFAULT_SINK = "@DEFAULT_SINK@";
  };

  assertions = [];

  warnings = lib.concatLists (map (font:
    if ! (builtins.elem font config.fonts.packages) then [
      ''
        SwayNC config uses '${font.name}', but it is not in 'fonts.packages'.
        Icons or text may not render correctly.
        Please add 'pkgs.${font.pname}' to 'fonts.packages' in your NixOS configuration.
      ''
    ] else []
  ) requiredFonts);
}
