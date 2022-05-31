# config-files (a.k.a. "dotfiles")
Many programs on UNIX-like operating systems store their settings in plain text files somewhere in the user's home directory. These files'
names often begin with a dot (".") so that they appear hidden in graphical file browsers. Developers and UNIX fans in general tend to check these
so-called "dotfiles" into version control in order to

- back up their programs' settings.
- sync these programs' settings across multiple devices so that they can have a consistent experience using these programs on different computers.

This is my "dotfiles" repo, although I have opted to call them "config(uration) files" instead of "dotfiles" because this repo also stores files
used by [NixOS][nixos], which do *not* begin with a dot. Not that it matters too much, but I felt the name made more sense since I am storing more
than literally dotfiles in this repo.

You are free to use whatever you find in this repo for your own dot/config files, or use this repo directly. Developers share dotfiles like home cooks
might share recipes &#x2014; a well-crafted `.bashrc` or `.vimrc` is the culmination of years of slight tweaking, hearing other users' workflows and
borrowing (stealing) from their config files, and whittling down what's unnecessary for their workflow until they have a truly optimized, personalized,
and organized file. To this end, I have tried my best to attribute any code snippets/settings/workflows I encountered on GitHub and the Internet in
general in the appropriate places in these files. If you take inspiration from any of those sections of those files, I ask that you keep the attribution
for the original author.

## Deploying These Config Files

I use [dotdrop] to manage my config files since, before symlinking them from this repo to their proper place somewhere else on the file system, it can
dynamically generate their contents dependent on many factors: operating system, if a certain program is installed or not, etc.

To install dotdrop, first create a Python virtual environment. There are many ways to do this: my favorite is using [virtualenv].

```bash
# Install virtualenv
pip3 install virtualenv

# Create the virtual environment
virtualenv env

# Activate the virtual environment
source env/bin/activate
```

Once inside the virtual environment, install dotdrop.

```bash
pip install dotdrop # or pip install -r requirements.txt
```

### Using dotdrop

Browse the dotdrop website to learn how to use it. Dotdrop has the notion of "profiles", which are sets of config files to be installed onto a machine.
For my config files, I have three profiles: one for macOS (`macos`), one for NixOS (`nixos`), and one for Linux distributions other than NixOS (`linux`).

To see which files belong to a particular profile, use

```bash
dotdrop files -p <profile>
```

You can install config files for a particular profile into a temporary directory before deploying them to your actual home directory with

```bash
dotdrop install -t -p <profile>
```

Upon issuing this command, the name of a temporary directory is printed that you can `cd` to to see what your home directory and the files that would
be installed look like before installing it "for real".

When you are confident with what will be installed, issue

```bash
dotdrop install -p <profile>
```

that is, the same command as above without the `-t` flag.

### NixOS
You'll notice upon `dotdrop files -p nixos` there is only one file in this profile: [`conf.toml`](org.dystroy.broot/conf.toml).
That is because, on NixOS, I use a combination of dotdrop and [Home Manager][home-manager] to manage my config files. NixOS is a really unique
Linux distribution and Nix is a neat tool that can be extended to do lots of things, and thus Home Manager allows Nix, NixOS' package manager, to manage
your config files as if they were system packages. Since it is idiomatic on NixOS to use Nix for as many things as possible, I have tried to incorporate
Nix as much as possible into managing my config files (on NixOS). The only reason I use dotdrop for `conf.toml` on NixOS is because of dotdrop's ability to
use templates to customize the contents of a config file before deploying it. I have not found an equivalent feature for Nix other than duplicating this
file, adding in the NixOS-specific settings, and pointing Nix to that file. My issue with this solution, and the reason I did not go with that, is
that I would have to keep two versions of `conf.toml` in sync with each other: one that is templated to abstract as much common configuration between macOS
and other Linux distributions as possible, and one that is specific to NixOS but also contains many configurations of the first version. In the end, I
decided to sacrifice a little purity that comes with using Nix for everything in exchange for de-duplicating files.

There are, however, some system configuration files for NixOS that first need to be deployed by dotdrop before all other configuration files (again, except
for `conf.toml`) can be managed by Nix, these being [`configuration.nix`](org.nixos.Nix/configuration.nix) and all the files in the [`joeyt`](org.nixos.Nix/joeyt)
directory. These need to be deployed to the system directory `/etc/nixos` which requires elevated privileges. For this reason, these system configuration files
are managed in a separate [`config_root.yaml`](config_root.yaml) file so that one does not accidentally install user-level config files as root. To install these
files, issue

```bash
sudo dotdrop install -c config_root.yaml -p nixos

# Rebuild your NixOS environment now that you have installed new configuration files
sudo nixos-rebuild switch # or sudo nixos-rebuild test to test the new environment without adding a new GRUB boot entry
```

## How This Repo is Organized
Most people's dotfiles repos are structured to mimic the structure of their home directory. For example, if their home directory looked like this:

```
~/
├── .bashrc
└── .config/
    ├── vim/
    │   └── .vimrc
    └── zsh/
        ├── .zprofile
        └── .zshrc
```

then the root of their dotfiles repo would look like

```
dotfiles/
├── .bashrc
└── .config/
    ├── vim/
    │   └── .vimrc
    └── zsh/
        ├── .zprofile
        └── .zshrc
```

However, with dotdrop, the source and destination directories for each dotfile is stored in
[`config.yaml`](config.yaml), which means I've opted to organize dotfiles by application.

In this repo, you will see directories for each program I use, named by their name and the reverse of the domain, similar to how Java packages are named.
All configuration files for that application are in that folder, along with another README explaing my setup for that application.

[nixos]: https://nixos.org/
[dotdrop]: https://deadc0de.re/dotdrop/
[virtualenv]: https://virtualenv.pypa.io/en/latest/
[home-manager]: https://nix-community.github.io/home-manager/
