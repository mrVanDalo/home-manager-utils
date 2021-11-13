{
  description = "home manager utilities";
  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
  outputs = { self, home-manager, ... }: {
    hmModules.git-pull = import ./git-pull.nix { hmlib = home-manager.lib; };
    hmModule = {
      imports = [ self.hmModules.git-pull ];
    };
  };
}
