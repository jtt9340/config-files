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
