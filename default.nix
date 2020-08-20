{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  pythonEnv =
    let
      dotdrop = python38.pkgs.buildPythonPackage rec {
        pname = "dotdrop";
        version = "1.1.0";

        src = fetchFromGitHub {
          owner = "jtt9340";
          repo = pname;
          rev = "2c964c9d11f61f8d0eb9ce9d83e37d9db08a9528";
          sha256 = "0pwvg0f45p2nm5fpfpklmlrc22wn744xp0v31ba6rx4hqbqasm8v";
        };

        doCheck = false;

        propagatedBuildInputs = with python38.pkgs; [
          jinja2
          docopt
          ruamel_yaml
        ];
      };
    in
      python38.withPackages (ps: with ps; [
        dotdrop
        virtualenv
      ]);
in mkShell {
  name = "config-files";

  buildInputs = [
    pythonEnv
  ];
}
