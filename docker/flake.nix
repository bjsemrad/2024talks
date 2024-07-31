{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "${system}"; };
    in
    {
      cowsay = pkgs.dockerTools.buildLayeredImage {
        name = "cowsay";
        tag = "latest";
        config = {
          Cmd = [ "${pkgs.cowsay}/bin/cowsay" "Hello GTG Tech Conference" ];
        };
      };
    };
}
