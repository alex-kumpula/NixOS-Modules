{
  description = "NixOS Modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ]; # Add other systems as needed

    forAllSystems = f:
      lib.genAttrs supportedSystems (system:
        f {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit system;
        }
      );

    lib = nixpkgs.lib;
  in
  {
    nixosModules = forAllSystems ({ pkgs, system }: {
      desktop = import ./desktop.nix { inherit pkgs system; };
      networking = import ./networking.nix { inherit pkgs system; };
      user = import ./user.nix { inherit pkgs system; };
      bootloader = import ./bootloader.nix { inherit pkgs system; };
    });
  };
}