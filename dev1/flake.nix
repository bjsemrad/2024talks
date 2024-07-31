{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "${system}"; };
    in
    {
      devShells.${system}.default =
        let
          jdk = pkgs.jdk17;  
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk
            nodejs_18
          ];
        };
    };
}
