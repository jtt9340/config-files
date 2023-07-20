{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  pythonEnv = let
    dotdrop = python310.pkgs.buildPythonPackage rec {
      pname = "dotdrop";
      version = "1.13.0";

      src = python310.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "sha256-8v7p1n0hrCpvzWCjHcaa3ingi46R2wlwuHv6UwlhhTo=";
      };

      # dotdrop is kind of hard to test -- until I can figure
      # out how to run the tests.sh script in the checkPhase
      # we will disable tests and just check to see that
      # "import dotdrop" doesn't crash.
      doCheck = false;

      # Runtime dependencies
      propagatedBuildInputs = with python310.pkgs; [
        jinja2
        docopt
        ruamel_yaml
        python_magic
        packaging
        requests
        toml
        distro
      ];

      pythonImportsCheck = [ "dotdrop" ];
    };
  in python310.withPackages (ps: with ps; [ dotdrop ]);
in mkShell {
  name = "config-files";

  buildInputs = [ pythonEnv ];
}
