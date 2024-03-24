{ batman # the batman program as part of the bat-extras package
, isLinux # Function that accepts a list and returns it if we are on Linux, an empty list otherwise
, isDarwin # Function that accepts a list and returns it if we are on Linux, an empty list otherwise
}:

{
  # Git config
  enable = true;
  userName = "Joey Territo";
  userEmail = "{{@@ git_email @@}}";
  extraConfig = {
    grep = {
      lineNumber = true;
      fallbackToNoIndex = true;
    };
    man.man.path = "${batman}/bin/batman";
    pull.ff = "only";
    advice.detachedHead = false;
    init.defaultBranch = "master";
    fetch.prune = true;
    commit.verbose = 1;
  };
  # Aliases heavily inspired (i.e. taken) from the Git Oh-My-Zsh plugin
  aliases = {
    a = "add";
    aa = "add --all";
    apa = "add --patch";
    au = "add --update";
    av = "add --verbose";
    ap = "apply";
    apt = "apply --3way";
    b = "branch";
    ba = "branch -a";
    bd = "branch -d";
    bD = "branch -D";
    bg = ''!git branch -vv | grep \": gone\\]\"'';
    bgd = ''
      !git branch --no-color -vv | grep \":gone\\]\" | awk '{print $1}' | xargs git branch -d'';
    bgD = ''
      !git branch --no-color -vv | grep \":gone\\]\" | awk '{print $1}' | xargs git branch -D'';
    bl = "blame -b -w";
    bnm = "branch --no-merged";
    br = "branch --remote";
    bs = "bisect";
    bsb = "bisect bad";
    bsg = "bisect good";
    bsr = "bisect reset";
    bss = "bisect start";
    c = "commit -v";
    ca = "commit -v -a";
    cb = "checkout -b";
    cf = "config --list";
    cl = "clone --recurse-submodules";
    clean = "clean --interactive -d";
    co = "checkout";
    cor = "checkout --recurse-submodules";
    count = "shortlog --summary --numbered";
    cp = "cherry-pick";
    cpa = "cherry-pick --abort";
    cpc = "cherry-pick --continue";
    cs = "commit -S";
    d = "diff";
    dca = "diff --cached";
    dcw = "diff --cached --word-diff";
    dct = "!git describe --tags $(git rev-list --tags --max-count=1)";
    ds = "diff --staged";
    dt = "diff-tree --no-commit-id --name-only -r";
    dup = "diff @{upstream}";
    dw = "diff --word-diff";
    f = "fetch";
    fa = "fetch --all --prune";
    fo = "fetch origin";
    hh = "help";
    ignore = "update-index --assume-unchanged";
    ignored = ''!git ls-files -v | grep \"^[[:lower:]]\"'';
    l = "pull";
    lg = "log --stat";
    lgp = "log --stat -p";
    lgg = "log --graph";
    lgga = "log --graph --decorate --all";
    lgm = "log --graph --max-count=10";
    lo = "log --oneline --decorate";
    lol =
      "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
    lols =
      "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat";
    lod =
      "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
    lods =
      "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
    lola =
      "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all";
    loga = "log --oneline --decorate --graph --all";
    m = "merge";
    ma = "merge --abort";
    ms = "merge --squash";
    p = "push";
    pd = "push --dry-run";
    pf = "push --force-with-lease";
    poat = "!git push origin --all && git push origin --tags";
    pu = "push upstream";
    pv = "push -v";
    pristine = "!git reset --hard && git clean --force -dfx";
    r = "remote";
    ra = "remote add";
    rb = "rebase";
    rba = "rebase --abort";
    rbc = "rebase --continue";
    rbd = "rebase develop";
    rbi = "rebase -i";
    rbs = "rebase --skip";
    rev = "revert";
    rh = "reset";
    rhh = "reset --hard";
    rmc = "rm --cached";
    rmv = "remote rename";
    rrm = "remote remove";
    rs = "restore";
    rset = "remote set-url";
    rss = "restore --source";
    rst = "restore --staged";
    ru = "reset --";
    rup = "remote update";
    rv = "remote -v";
    sb = "status -sb";
    sh = "show";
    si = "submodule init";
    sps = "show --pretty=short";
    ss = "status -s";
    st = "status";
    sta = "stash push";
    staa = "stash apply";
    stc = "stash clear";
    std = "stash drop";
    stl = "stash list";
    stp = "stash pop";
    sts = "stash show --text";
    stu = "stash --include-untracked";
    stall = "stash --all";
    su = "submodule update";
    sw = "switch";
    swc = "switch -c";
    ts = "tsg -s";
    tv = "!git tag | sort -V";
    unignore = "update-index --no-assume-unchanged";
    unwip = ''
      !git rev-list --max-count=1 --format="%s" HEAD | grep -q \"\\--wip--\" && git reset HEAD~1'';
    pr = "pull --rebase";
    prv = "pull --rebase -v";
    pra = "pull --rebase --autostash";
    prav = "pull --rebase --autostash -v";
    wch = "whatchanged -p --abbrev-commit --pretty=medium";
    wip = ''
      "!git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\""'';
    wt = "worktree";
    wta = "worktree add";
    wtls = "worktree list";
    wtmv = "worktree move";
    wtrm = "worktree remove";
    amc = "am --continue";
    ams = "am --skip";
    ama = "am --abort";
    amscp = "am --show-current-patch";
    i =
      "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
  };
  ignores = isLinux [
    # Generated by the "i" alias (see above)
    "*~"
    ".fuse_hidden*" # temporary files which can be created if a process still has a handle open of a deleted file
    ".directory" # KDE directory preferences
    ".Trash-*" # trash folder which might appear on any partition or disk
    ".nfs*" # .nfs files are created when an open file is removed but is still being access
  ] ++ isDarwin [
    # General
    ".DS_Store"
    ".AppleDouble"
    ".LSOverride"
    "Icon\r\r"
    # Thumbnails
    "._*"
    # Files that might appear in the root of a volume
    ".DocumentRevisions-V100"
    ".fseventsd"
    ".Spotlight-V100"
    ".TemporaryItems"
    ".Trashes"
    ".VolumeIcon.icns"
    ".com.apple.timemachine.donotpresent"
    # Directories potentially created on remote AFP share
    ".AppleDB"
    ".AppleDesktop"
    "Network Trash Folder"
    "Temporary Items"
    ".apdisk"
    # iCloud generated files
    "*.icloud"
  ];
  # Use Delta, a diff tool that makes diffs look like they do on GitHub
  delta = {
    # Delta config
    enable = true;
    options = {
      syntax-theme = "OneHalfDark";
      whitespace-error-style = "22 reverse";
      file-style = "bold cyan ul";
      file-decoration-style = "cyan ul";
      line-numbers = true;
      line-numbers-left-style = "cyan";
      line-numbers-right-style = "cyan";
      hunk-header-decoration-style = "cyan box";
    };
  };
}
