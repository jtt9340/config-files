# The "batman" parameter is the batman program as part of the bat-extras package
batman:

{
  # Git config
  enable = true;
  userName = "Joey Territo";
  {%@@ if env['git-email'] is string @@%}
  userEmail = "{{@@ env['git-email'] @@}}";
  {%@@ endif @@%}
  extraConfig = {
    grep = {
      lineNumber = true;
      fallbackToNoIndex = true;
    };
    man.man.path = "${batman}/bin/batman";
  };
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
    co = "checkout";
    cp = "cherry-pick";
    cpc = "cherry-pick --continue";
    cs = "commit -S";
    d = "diff";
    dca = "diff --cached";
    dcw = "diff --cached --word-diff";
    ds = "diff --staged";
    dt = "diff-tree --no-commit-id --name-only -r";
    dw = "diff --word-diff";
    f = "fetch";
    fa = "fetch --all --prune";
    fo = "fetch origin";
    hh = "help";
    ignore = "update-index --assume-unchanged";
    l = "pull";
    lg = "log --stat";
    lgp = "log --stat -p";
    lgg = "log --graph";
    lgga = "log --graph --decorate --all";
    lgm = "log --graph --max-count=10";
    lo = "log --oneline --decorate";
    lol = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
    lols = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat";
    lod = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
    lods = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
    lola = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all";
    loga = "log --oneline --decorate --graph --all";
    m = "merge";
    ma = "merge --abort";
    p = "push";
    pd = "push --dry-run";
    pf = "push --force-with-lease";
    pu = "push upstream";
    pv = "push -v";
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
    unignore = "update-index --no-assume-unchanged";
    up = "pull --rebase";
    upv = "pull --rebase -v";
    upa = "pull --rebase --autostash";
    upav = "pull --rebase --autostash -v";
    wch = "whatchanged -p --abbrev-commit --pretty=medium";
    amc = "am --continue";
    ams = "am --skip";
    ama = "am --abort";
    amscp = "am --show-current-patch";
  };
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
