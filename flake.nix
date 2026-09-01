{
  description = "A very simple development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # define your python packages here
      pythonEnv = pkgs.python3.withPackages(ps: with ps; [
        jupyter
        numpy
        pandas
        matplotlib
        torch
        # add other dependencies here
      ]);
    
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ 
          pythonEnv
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.glibc
        ];
        
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
       
       
        shellHook = ''
          alias vim=nvim
          export VENV_DIR="$PWD/.venv"
          if [ ! -d "$VENV_DIR" ]; then
            echo "Creating python virtual environment..."
            python -m venv "$VENV_DIR"
          fi

          ## Activate virtual environment
          source "$VENV_DIR/bin/activate"
          
          echo "Installing the environment..."
          
          pip install --upgrade pip
          
          pip install google-adk ipykernel litellm numpy matplotlib torch mcp google-adk[mcp] transformers scikit-learn inspect-ai inspect-evals inspect-harbor langchain langchain-ollama langchain-chroma langchain_community pandas jq dotenv pypdf langgraph deepagents
          python -m ipykernel install --user --name .venv
          echo "write 'jupyter notebook' to jump into jupyter environment..."
          # jupyter notebook
        '';
      };
    };
}
