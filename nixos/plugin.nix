# plugin.nix
{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lua5_4,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin (finalAttrs: {
  pluginName = "scrolloverview";
  version = "0-unstable-2026-08-03";
  src = fetchFromGitHub {
    owner = "yayuuu";
    repo = "hyprland-scroll-overview";
    rev = "16eb0f851faa308ce3e4a982316ffc8f3d2a2085";
    hash = "sha256-TWUKtHT/RoF5EqETCPyZZiyVVOUzZRHottpHAaE0El4=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
    lua5_4
  ];
  buildInputs = [ ];
  meta = {
    homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
    description = "Scroll overview plugin, just like niri";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
