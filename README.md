# home-manager-utils

## git-pull

> pull git repositories automatically.

Example: 

``` nix
home.git-pull.enable = true; # usefull if you don't have ssh set up yet
home.git-pull.repositories = [
    { 
      source = "git@github.com:mrVanDalo/home-manager-utils.git";
      target = "~/Development/home-manager-utils";
    }
    { 
      source = "git@github.com:terranix/terranix.git";
      target = "~/Development/terranix";
    }
];
```

## use with flakes

``` nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-21.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.home-manager-utils = {
    url = "github:mrvandalo/home-manager-utils";
    inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, home-manager, home-manager-utils, ... }:
    let
      nixosSystem = nixpkgs.lib.nixosSystem;
    in {
      
      # us it in you nixosConfiguration
      nixosConfigurations.example = nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModule
          {
            home-manager.users.exampleUser.imports = [ home-manager-utils.hmModule ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      
      # or use it as homeManagerConfiguration 
      homeManagerConfigurations = {
        darwin = home-manager.lib.homeManagerConfiguration {
          configuration = ./home.nix;
          extraModules = [ home-manager-utils.hmModule ];
          system = "x86_64-darwin";
          homeDirectory = "/Users/mrvandalo";
          username = "mrvandalo";
        };
      };
    };
}
```


