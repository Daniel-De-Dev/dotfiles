{ pkgs, config, lib, ... }:
{
  packages = with pkgs; [
    # Core
    hyprpaper
    hypridle
    hyprlock
    waybar
    swaynotificationcenter
    rofi
    wlogout

    # Tools & Utilities
    kitty
    jq
    killall
    polkit_gnome
    wtype
    hyprpicker
    wdisplays

    # Audio & Media
    wireplumber
    playerctl
    pulseaudio
    pavucontrol

    # Network & Bluetooth
    networkmanagerapplet
    blueman

    # Screenshot & Recording
    grim
    grimblast
    slurp
    wf-recorder

    # Theming & Visuals
    openzone-cursors
    qt6Packages.qt6ct
    hyprshade
    waypaper

    # Applications
    brave
    gimp
    qalculate-qt
    bemoji
    yazi

    # System Dependencies
    brightnessctl
    wl-clipboard
    cliphist
    libnotify
  ];

  variables = {
    terminal = lib.getExe pkgs.kitty;
    kbLayout = config.my.host.keyMap;
    cursorTheme = "OpenZone_Black";
    cursorSize = "24";
    monitorConfig = "monitor=,preferred,auto,1";
    polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    DEFAULT_AUDIO_SINK = "@DEFAULT_AUDIO_SINK@";
    DEFAULT_SINK = "@DEFAULT_SINK@";
    DEFAULT_SOURCE = "@DEFAULT_SOURCE@";
  };

  assertions = [
    {
      assertion = config.programs.hyprland.enable;
      message = "programs.hyprland.enable must be for this config to work.";
    }
    {
      assertion = config.security.polkit.enable;
      message = "Hyprland expects security.polkit.enable to be true";
    }
  ];

  warnings = [];
}
