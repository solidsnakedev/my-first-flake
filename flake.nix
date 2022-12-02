{ 
  description = "A very basic flake";

  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    CHaP = {
      url = "github:input-output-hk/cardano-haskell-packages?ref=repo";
      flake = false;
    };
  };
    
  outputs = { self, nixpkgs, flake-utils, haskellNix , CHaP}@inputs: 

    flake-utils.lib.eachSystem [ "x86_64-linux"] (system:

    let
      overlays = [ haskellNix.overlay
        (final: prev: {
          # This overlay adds our project to pkgs
          helloProject =
            final.haskell-nix.cabalProject' {
              src = ./.;
              compiler-nix-name = "ghc925";
              # This is used by `nix develop .` to open a shell for use with
              # `cabal`, `hlint` and `haskell-language-server`
              
              shell = {
                tools = {
                cabal = { };
                hlint = {};
                haskell-language-server = { };
              };

                buildInputs = with pkgs; [
                  nixpkgs-fmt
                  fd
                  git
                  gnumake
                ];
                additional = ps: [ps.plutarch ps.ply-core];
              exactDeps = true;
              withHoogle = true;
           };

              inputMap = { "https://input-output-hk.github.io/cardano-haskell-packages" = inputs.CHaP; };

            };
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };


      # pkgs = import nixpkgs {
      #     inherit system;
      #     overlays = [
      #       haskellNix.overlay
      #     ];
      #     inherit (haskellNix) config;
      #   };

      # helloProject = pkgs.haskell-nix.cabalProject' {
      #     src = ./.;
      #     compiler-nix-name = "ghc925";
      #     #modules = [ (plutarch.haskellModule system) ];
      #     shell = {
      #       # This is used by `nix develop .` to open a shell for use with
      #       # `cabal`, `hlint` and `haskell-language-server` etc
      #       tools = {
      #         cabal = { };
      #         hlint = {};
      #         haskell-language-server = { };
      #       };
      #       # Non-Haskell shell tools go here
      #       buildInputs = with pkgs; [
      #         nixpkgs-fmt
      #         fd
      #         git
      #         gnumake
      #       ];
      #       withHoogle = true;
      #     };


      #     inputMap = { "https://input-output-hk.github.io/cardano-haskell-packages" = inputs.CHaP; };
      #   };

      flake = pkgs.helloProject.flake {};
    in flake // {
      # Built by `nix build .`
      packages.default = flake.packages."my-first-flake:exe:my-first-flake";
    });

  nixConfig = {
    #bash-prompt = "\\[\\e[0m\\][\\[\\e[0;92m\\]Nix Develop\\[\\e[0m\\]] \\[\\e[0;93m\\]\\w\\[\\e[0m\\]$\\[\\e[0m\\] ";
    bash-prompt = "\\[\\e[0;92m\\][\\[\\e[0;92m\\]nix develop:\\[\\e[0;92m\\]\\w\\[\\e[0;92m\\]]\\[\\e[0;92m\\]$ \\[\\e[0m\\]";
  };
}

# nix repl
# :lf .