{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  pythonEnv =
    let
      dotdrop = python39.pkgs.buildPythonPackage rec {
        pname = "dotdrop";
        version = "1.4.3";

        src = fetchFromGitHub {
          owner = "jtt9340";
          repo = pname;
          rev = "v${version}";
          sha256 = "16pc4gh1cc795ckwswpbmzc7k0k6ki6mzmgy7lsvpwyal80rl773";
        };

        doCheck = false;

        propagatedBuildInputs = with python39.pkgs; [
          jinja2
          docopt
          ruamel_yaml
          python_magic
        ];
      };
    in
      python39.withPackages (ps: with ps; [
        dotdrop
      ]);
in mkShell {
  name = "config-files";

  buildInputs = [
    pythonEnv
  ];
}
