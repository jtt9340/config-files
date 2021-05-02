{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  pythonEnv =
    let
      dotdrop = python39.pkgs.buildPythonPackage rec {
        pname = "dotdrop";
        version = "1.5.3";

        src = fetchFromGitHub {
          owner = "deadc0de6";
          repo = pname;
          rev = "v${version}";
          sha256 = "1qqlh9pznssbgg45qvxw73j4ii1hl1y118lyaldblmjqhdc65768";
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
