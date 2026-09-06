{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.inputs.home-manager.follows = "home-manager";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lollypops.url = "github:pinpox/lollypops";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      impermanence,
      home-manager,
      lollypops,
      disko,
      ...
    }:
    {
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
            home-manager.extraSpecialArgs = {
              flakeInputs = inputs;
            };
          }
          impermanence.nixosModules.impermanence
          lollypops.nixosModules.default
        ];
      };

      nixosConfigurations.alpha = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/alpha/configuration.nix
          impermanence.nixosModules.impermanence
          disko.nixosModules.disko
          ./hosts/alpha/disko-config.nix
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

      packages."x86_64-linux".lollypops = lollypops.packages."x86_64-linux".default.override {
        configFlake = self;
      };

      formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".nixfmt-tree;
      formatter."x86_64-darwin" = nixpkgs.legacyPackages."x64_64-darwin".nixfmt-tree;
    };
}
