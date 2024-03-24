generateJson:

generateJson "coc-settings.json" {
  "suggest.autoTrigger" = true;
  languageserver = {
    haskell = {
      command = "haskell-language-server-wrapper";
      args = [ "--lsp" ];
      rootPatterns =
        [ "*.cabal" "stack.yaml" "cabal.project" "package.yaml" "hie.yaml" ];
      filetypes = [ "haskell" "lhaskell" ];
      settings.haskell.formattingProvider = "ormolu";
    };
  };
}
