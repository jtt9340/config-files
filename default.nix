{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  pythonEnv = let
    dotdrop = python39.pkgs.buildPythonPackage rec {
      pname = "dotdrop";
      version = "1.12.1";

      src = python39.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "bvr1Oqw03Qq+PN+ts5huBnWb7SUT5Xy+w/AUCI201QA=";
      };

      # dotdrop is kind of hard to test -- until I can figure
      # out how to run the tests.sh script in the checkPhase
      # we will disable tests and just check to see that
      # "import dotdrop" doesn't crash.
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
        distro
      ];

      pythonImportsCheck = [ "dotdrop" ];
    };
  in python39.withPackages (ps: with ps; [ dotdrop ]);
in mkShell {
  name = "config-files";

  buildInputs = [ pythonEnv ];
}
