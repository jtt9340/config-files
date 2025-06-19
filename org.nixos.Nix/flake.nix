{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # TODO Replace with upstream main branch once this PR has been merged
    lollypops.url = "github:pinpox/lollypops?ref=pull/56/head";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, impermanence, home-manager
    , lollypops, ... }: {
      nixosConfigurations.nicksauce = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/nicksauce/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.joeyt = ./users/joeyt/home.nix;
            home-manager.extraSpecialArgs = { flakeInputs = inputs; };
          }
          impermanence.nixosModules.impermanence
          lollypops.nixosModules.default
        ];
      };

      darwinConfigurations."Joeys-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          ./hosts/Joeys-MacBook-Pro-2/configuration.nix
          home-manager.darwinModules.home-manager
          { home-manager.users.josephterrito = ./users/joeyt/home.nix; }
        ];
      };

      packages."x86_64-linux".lollypops =
        lollypops.packages."x86_64-linux".default.override {
          configFlake = self;
        };

      formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".nixfmt;
      formatter."x86_64-darwin" = nixpkgs.legacyPackages."x64_64-darwin".nixfmt;
    };
}
