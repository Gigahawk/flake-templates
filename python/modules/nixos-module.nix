{
  self,
  moduleWithSystem,
  ...
}:
{
  flake =
    { config, ... }:
    {
      nixosModules.default = moduleWithSystem (
        perSystem@{ config }:
        nixos@{
          config,
          lib,
          pkgs,
          ...
        }:
        let
          moduleName = "hello-service";
          serviceDesc = "Service description";
          cfg = config.services.${moduleName};
          pkg = perSystem.config.packages.default;
          inherit (lib)
            mkEnableOption
            mkOption
            mkIf
            types
            ;
        in
        {
          options.services.${moduleName} = {
            enable = mkEnableOption serviceDesc;

            testOption = mkOption {
              description = "Sample option";
              type = types.str;
            };

            serviceUser = mkOption {
              description = "User to run the service under";
              type = types.str;
              default = "${moduleName}-user";
            };
          };
          config = mkIf cfg.enable {
            users.users.${cfg.serviceUser} = {
              group = cfg.serviceUser;
              isSystemUser = true;
              description = "${moduleName} service user";
            };

            users.groups.${cfg.serviceUser} = { };
            systemd = {
              services.${moduleName} = {
                description = serviceDesc;
                wantedBy = [ "multi-user.target" ];
                after = [
                  "network-online.target"
                ];
                wants = [ "network-online.target" ];

                serviceConfig = {
                  User = cfg.serviceUser;
                  Group = cfg.serviceUser;

                  ExecStart = ''
                    ${pkg}/bin/hello-python
                  '';
                };
              };
            };
          };
        }
      );

    };
}
