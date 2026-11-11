{
  description = "dev";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    eza.url = "github:eza-community/eza";
  };
  outputs =
    {
      self,
      eza,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packagesFor = [
          eza.packages.${system}.default
          pkgs.fish
          pkgs.fzf
          pkgs.neovim
          pkgs.ripgrep
          pkgs.tmux
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
        formatter = pkgs.nixfmt;
      }
    );
}
