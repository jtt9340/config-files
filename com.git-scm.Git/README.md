# git

[Git has a top-level config file][git-config]. Each line in my git config has a comment explaining what it
does, so hopefully it is clear what each setting does.

I think there are only three notable things worth mentioning here. The first is that I am taking advantage of
dotdrop's [uservariables feature][uservariables] to store the email referenced in git commits. I don't want
to store my email in my config-files repo, so this will prompt for an email upon the first time deploying my git
config - this email will be used in all future deployments. To change the email, edit the dotdrop-generated
`uservariables.yaml`.

The second notable thing is all the git aliases I have set up. As you'll see in my
[zsh configuration](../net.sourceforge.Zsh/README.md), I use Oh My Zsh's git plugin, which defines a bunch
of (shell) aliases for git: things like `gco` for `git checkout` and `ga` for `git add`. I added these aliases
as git aliases as well so that there was consistency between `gco` and `git co`, or even `g co` as I have `g`
aliased to `git`. I sometimes also uses git's `-C` flag which allows you to specify the directory of the repo
you want git to act upon if you are not currently in that repo. That allows me to issue commands like
`git -C ../project a .` and still use the git aliases I have built up from muscle memory from using the ones
defined in the Oh My Zsh git plugin so much.

Lastly, if you are a heavy Git command line user (as opposed to using a graphical git interface like Git Kraken)
I really like [Dan Davison's delta][git-delta]. Rather than use its own configuration file (and thus make you check
more into your dotfiles repo and manage more things), it just adds settings to gitconfig, so you will see that
in mine. Notice how I use [dotdrop's templating feature][templating] to ensure these options are only deployed
to my git config if delta is installed on the machine.

[git-config]: https://git-scm.com/docs/git-config
[git-delta]: https://github.com/dandavison/delta
[uservariables]: https://dotdrop.readthedocs.io/en/latest/howto/prompt-user-for-variables/
[templating]: https://dotdrop.readthedocs.io/en/latest/template/templating/
