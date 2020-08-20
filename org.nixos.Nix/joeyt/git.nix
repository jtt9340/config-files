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
  };
}
