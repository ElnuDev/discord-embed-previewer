{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.${system}.default = with pkgs; mkShell {
        inputsFrom = [ self.packages.${system}.default ];
        shellHook = ''
          npm install --silent
        '';
      };
      packages.${system} = let
        pname = "discord-embed-previewer";
        version = "1.1.1";
        build = pkgs.buildNpmPackage {
          inherit pname version;
          src = ./.;
          npmDepsHash = "sha256-gNiyir7wtayEWAawXgzNZqlD/w2D8xNGFUXEBxZNjG8=";
          npmBuildScript = "build";
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r public/. $out/
            runHook postInstall
          '';
        };
      in {
        default = build;
      };
    };
}
