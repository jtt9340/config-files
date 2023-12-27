{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  pythonEnv = let
    dotdrop = python311.pkgs.buildPythonPackage rec {
      pname = "dotdrop";
      version = "1.14.0";

      src = python310.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "sha256-Z3Nhrzeu9XWs1SM946ixs9i3vPHzWHlG0InjRFA6ok0=";
      };

      # dotdrop is kind of hard to test -- until I can figure
      # out how to run the tests.sh script in the checkPhase
      # we will disable tests and just check to see that
      # "import dotdrop" doesn't crash.
      doCheck = false;

      # Runtime dependencies
      propagatedBuildInputs = with python311.pkgs; [
        jinja2
        docopt
        ruamel_yaml
        python_magic
        packaging
        requests
        tomli-w
        distro
      ];

      pythonImportsCheck = [ "dotdrop" ];
    };
  in python311.withPackages (ps: with ps; [ dotdrop ]);
in mkShell {
  name = "config-files";

  buildInputs = [ pythonEnv ];
}
