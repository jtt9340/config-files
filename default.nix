{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  pythonEnv = let
    dotdrop = python39.pkgs.buildPythonPackage rec {
      pname = "dotdrop";
      version = "1.10.3";

      src = python39.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "1xadmf2rbclr0c7x8wd6c7xfgx3ax8gcx9k4gllwfh6vb4vbgxbv";
      };

      # TODO: Figure out how to get the unit tests to pass so that
      # this can be set to true
      doCheck = false;

      # Runtime dependencies
      propagatedBuildInputs = with python39.pkgs; [
        jinja2
        docopt
        ruamel_yaml
        python_magic
        packaging
        requests
        toml
      ];

      # Build/test time dependencies
      # Uncomment when doCheck can be set to true
      # nativeBuildInputs = with python39.pkgs; [
      #   pycodestyle
      #   nose
      #   coverage
      #   coveralls
      #   pyflakes
      #   pylint
      #   halo
      #   file
      # ];
    };
  in python39.withPackages (ps: with ps; [ dotdrop ]);
in mkShell {
  name = "config-files";

  buildInputs = [ pythonEnv ];
}
