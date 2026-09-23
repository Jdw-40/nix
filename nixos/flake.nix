{
  description = "NixOS config (thinkpad)";
  inputs = {
    # Force both inputs to use the exact same stable release branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal.url = "github:aylur/astal";
    ags.url = "github:aylur/ags";

    lyse.url = "github:Jdw-40/lyse-flake"; # lyrics
    lyse.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    ie-r.url = "github:miaupaw/ie-r";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-scroll-overview = {
      url = "github:yayuuu/hyprland-scroll-overview/new-release";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hyprland,
      hyprland-scroll-overview,
      ...
    }@inputs:
    {
      nixosConfigurations.mrjw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix

          # Unified home-manager module injection
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.useUserPackages = false;
            home-manager.users.mrjw = import ./home.nix;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };
    };
}
