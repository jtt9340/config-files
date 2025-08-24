This directory contains secrets I don't want stored in plaintext in this repo.
They are encrypted with [age][age], a tool that lets you encrypt and decrypt files with the SSH keys you already use.
The reason they need to be stored in this repo at all is that, when using its "flakes" feature, Nix enforces reproducibility by only accessing files that are checked into your Git repo.
By enforcing that, you cannot have special files that your configuration is dependent on that you cannot reproduce on another machine.
This rule, however, makes secrets management a little tricky since, like I said, you don't want to store these in plaintext in your repo.
Luckily, [lollypops][lollypops] has support for secret management, so I can store secrets in my repo and have it decrypt them upon deploying to a host!

[age]: https://age-encryption.org/
[lollypops]: https://github.com/pinpox/lollypops
