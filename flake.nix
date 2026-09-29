{
  description = "atidyshirt/neovim - standalone, installable Neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        runtimeInputs = with pkgs; [
          neovim-unwrapped
          gitMinimal
          curl
          jq
          ripgrep
          fd
          nodejs-slim
          nodejs-slim.npm
          python3Minimal
          luajit
          cacert
          tree-sitter
        ];

        nvim = pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = runtimeInputs;
          text = ''
            # vim.pack hardcodes its lockfile at $XDG_CONFIG_HOME/nvim/nvim-pack-lock.json
            # with no override hook, so XDG_CONFIG_HOME must be writable. Seed a
            # local, writable copy from this (read-only) store path on first run,
            # then reuse it - vim.pack.update() and friends work normally from then on.
            runtime_home="''${XDG_STATE_HOME:-$HOME/.local/state}/atidyshirt-neovim"
            if [ ! -e "$runtime_home/nvim/init.lua" ]; then
              mkdir -p "$runtime_home"
              rm -rf "$runtime_home/nvim"
              cp -r "${self}" "$runtime_home/nvim"
              chmod -R u+w "$runtime_home/nvim"
            fi
            export XDG_CONFIG_HOME="$runtime_home"
            exec nvim "$@"
          '';
        };
      in
      {
        packages.default = nvim;
        packages.nvim = nvim;

        apps.default = {
          type = "app";
          program = "${nvim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ stylua pre-commit neovim-unwrapped ];
        };
      }
    );
}
