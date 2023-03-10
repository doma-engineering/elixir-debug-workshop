{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
    };

    outputs = {self, nixpkgs}:
        let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
            defaultPackage.x86_64-linux = pkgs.hello;

            devShell.x86_64-linux =
                pkgs.mkShell {
                    buildInputs = [
                        pkgs.elixir
                        pkgs.erlang
                        pkgs.inotify-tools
                        pkgs.postgresql
                        pkgs.openssl
                        # Helpers
                        pkgs.httpie
                        pkgs.jq
                        pkgs.yq
                        pkgs.dig
                    ];
                };
        };
}
