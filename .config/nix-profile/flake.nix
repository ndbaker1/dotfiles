{
  description = "dev";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/4100e830e085863741bc69b156ec4ccd53ab5be0";
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packagesFor = [
          pkgs.fish
          pkgs.tmux
          pkgs.neovim
          pkgs.fzf
          pkgs.ripgrep
        ];
      in
      {
        packages.default = pkgs.buildEnv {
          name = "dev";
          paths = packagesFor;
        };
        devShells.default = pkgs.mkShell {
          packages = packagesFor;
        };
      }
    );
}
