{ stdenv, rustPlatform, fetchFromGitHub, pkgs, ... }:

let
  githubUser = "lf-";
  githubRepo = "nix-doc";
in rustPlatform.buildRustPackage rec {
  pname = githubRepo;
  version = "v0.4.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = githubUser;
    rev = version;
    sha256 = "1im5qiszp5nk04083r9il05kybmrqa41bvm1axzd1r6bzdvw8xzq";
  };

  buildInputs = with pkgs; [ boost nix ];

  nativeBuildInputs = with pkgs; [ pkg-config ];

  cargoSha256 = "1g0m3qz1svr52861iq2w6aqvl75qq1vj15j29fp7jw01lhrzqgnw";

  meta = with stdenv.lib; {
    homepage = "https://github.com/${githubUser}/${githubRepo}";
    licence = licenses.lgpl3;
    description =
      "A Nix documentation lookup tool that quickly dumps the docs of the library function";
  };
}
