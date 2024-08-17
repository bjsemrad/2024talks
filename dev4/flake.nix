{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
      jdk = pkgs.jdk17;
      gradle-pkg = (pkgs.callPackage pkgs.gradle-packages.gradle_8 { java = jdk; });
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          nodejs
          gradle-pkg
          jetbrains.idea-community-bin
          apacheKafka_3_4
          awscli2
          vault-bin
        ];
      };

      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "gtg-demo";
        src = ./.;
        __impure = true; #Allow us to talk to the internet (generally a no no)

        nativeBuildInputs = [gradle-pkg pkgs.makeWrapper];

        buildPhase = ''
          export GRADLE_USER_HOME=$(mktemp -d)
          gradle --no-daemon installDist
        '';

        installPhase = ''
          mkdir -p $out/share/gtg-demo
          cp -r app/build/install/app/* $out/share/gtg-demo
          makeWrapper $out/share/gtg-demo/bin/app $out/bin/app --set JAVA_HOME ${jdk}
        '';

        meta.mainProgram = "app";
      };
    };
}
