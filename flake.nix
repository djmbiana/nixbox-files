{
  description = "marie's nix configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.suckless = pkgs.mkShell {
        # toolchain + headers/libs
        packages = with pkgs; [
          pkg-config
          xorg.libX11
          xorg.libXft
          xorg.libXinerama
          fontconfig
          freetype
          harfbuzz
          gcc
          gnumake
        ];
      };
    nixosConfigurations = {
        nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixbox/configuration.nix
          # home manager module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.marie = import ./hosts/nixbox/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
        nixpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixpad/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.marie = import ./hosts/thinkpad/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    }; 
  };
}
