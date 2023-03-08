{
  description = "Plasma Manager Example";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = { nixpkgs, nixgl, home-manager, plasma-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "manmeet";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (self: super: { inherit nixgl; }) ];
      };
      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./gui.nix
          ./x11.nix
          {
            home = {
              stateVersion = "22.11";
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
        ];
      };
    in {
      packages.${system}.default = homeConfig.activationPackage;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ home-manager.packages.${system}.home-manager ];
      };
    };
}
