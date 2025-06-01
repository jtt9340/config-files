{
  description = "Joey's Darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }: {
    darwinConfigurations."Joeys-MacBook-Pro-2" =
      nix-darwin.lib.darwinSystem { modules = [ ./configuration.nix home-manager.darwinModules.home-manager ]; };
  };
}
