{
  description = "dev";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/4100e830e085863741bc69b156ec4ccd53ab5be0";
  };
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      packagesFor = pkgs: [
        pkgs.fish
        pkgs.tmux
        pkgs.neovim
        pkgs.fzf
        pkgs.ripgrep
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildEnv {
            name = "dev";
            paths = packagesFor pkgs;
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = packagesFor pkgs;
          };
        }
      );
    };
}
