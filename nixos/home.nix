{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  home = {
    username = "mrjw";
    homeDirectory = "/home/mrjw";
    stateVersion = "26.05";

    packages = with pkgs; [
      hello
      btop
      awww # wallpaper util
      #hyprtools
      hyprlock
      hyprshot
      hypridle
      hyprcursor
      hyprpolkitagent
      hyprshutdown
      ncmpcpp
      mpdris2
      swayosd
      nwg-look
      wl-clipboard # clipboard
      cliphist # clipboard
      networkmanagerapplet
      blueman
      ffmpeg
      nwg-displays

      eloquent

      #language servers
      lua-language-server
      nil
      nixd

      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.ie-r.packages.${pkgs.system}.default

      inputs.lyse.packages.${pkgs.system}.default

    ];
  };
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
  ];
  services.mpd = {
    enable = true;
    musicDirectory = "/home/mrjw/Music";
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "qml"
      "lua"
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags

    # additional packages and executables to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.battery
      inputs.astal.packages.${pkgs.system}.battery
      inputs.astal.packages.${pkgs.system}.hyprland
      inputs.astal.packages.${pkgs.system}.mpris
      inputs.astal.packages.${pkgs.system}.network
      inputs.astal.packages.${pkgs.system}.wireplumber
      inputs.astal.packages.${pkgs.system}.bluetooth
      inputs.astal.packages.${pkgs.system}.apps
      inputs.astal.packages.${pkgs.system}.auth
      inputs.astal.packages.${pkgs.system}.cava
      # inputs.astal.packages.${pkgs.system}.gcheatsheet # REMOVED: does not exist in Astal inputs
      inputs.astal.packages.${pkgs.system}.notifd
      inputs.astal.packages.${pkgs.system}.powerprofiles
      inputs.astal.packages.${pkgs.system}.tray

      fzf
      brightnessctl
      fd
    ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-scroll-overview.packages.${pkgs.stdenv.hostPlatform.system}.scrolloverview
    ];
  };

  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink /home/mrjw/.config/hypr/my-hyprland.lua;

  xdg.configFile."hypr/nixosPlugins.lua".text = ''
    return {
      scrolloverview = "${
        inputs.hyprland-scroll-overview.packages.${pkgs.stdenv.hostPlatform.system}.scrolloverview
      }/lib/libscrolloverview.so",
    }
  '';

  programs.home-manager.enable = true;
}
