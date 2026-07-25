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
        version = "1.0.1";
        build = pkgs.buildNpmPackage {
          inherit pname version;
          src = ./.;
          npmDepsHash = "sha256-icfR6vT9IwKWdTW877HN5AyQXOsyj9qDh4d2T6Me81k=";
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
