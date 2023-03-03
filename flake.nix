{
  description = "Plasma Manager Example";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      username = "manmeet";
      pkgs = import inputs.nixpkgs { inherit system; };
      homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./home.nix
          {
            home = {
              stateVersion = "23.05";
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
        ];
      };
    in {
      packages.${system}.default = homeConfig.activationPackage;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ inputs.home-manager.packages.${system}.home-manager ];
      };
    };
}
