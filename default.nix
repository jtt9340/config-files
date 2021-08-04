{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  pythonEnv =
    let
      dotdrop = python39.pkgs.buildPythonPackage rec {
        pname = "dotdrop";
        version = "1.5.4";

        src = fetchFromGitHub {
          owner = "deadc0de6";
          repo = pname;
          rev = "v${version}";
          sha256 = "03bisnmlly83qxjvx3pzf9ijw7hmmqmz043jrbn3aa5kch8yh4qz";
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
