Nix becomes even more powerful when you integrate [Home Manager][home-manager] &#x2014; it allows Nix to manage your config files for you.
As outlined in the linked manual, there are several ways to set it up; I've opted to install it as a NixOS module, so that user-specific configuration can live alongside host-wide configuration.
For organizational purposes, I have included all my user-specific configurations in their own directory to be imported by the main `configuration.nix`, broken down by program.

[home-manager]: https://rycee.gitlab.io/home-manager/
