{
  description = "home manager utilities";
  outputs = { self, ... }: {
    nixosModule = import ./modules;
    nixosModules.home-manager-utils = self.nixosModule;
  };
}
