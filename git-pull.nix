{ hmlib }:
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.home.git-pull;
in {
  options.home.git-pull = {
    enable = mkEnableOption "git repositories";
    repositories = mkOption {
      description = "directory structure";
      default = [ ];
      type = with types;
        listOf (submodule {
          options = {
            source = mkOption {
              type = with types; str;
              description = "repository to clone";
            };
            target = mkOption {
              type = with types; str;
              description = "directory to safe the repository";
            };
          };
        });
    };
  };

  config = mkIf cfg.enable {
    home.activation = let
    in {
      downloadGitRepositories = hmlib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # clone repositories
        ${lib.concatStringsSep "\n" (map ({ source, target }: ''
          if [[ ! -d ${target} ]]
          then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p $( ${pkgs.coreutils}/bin/dirname ${target} )
            $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${source} ${target}
          fi
        '') cfg.repositories)}
      '';
    };
  };
}
