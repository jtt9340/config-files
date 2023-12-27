# Configuation settings for Vim
{ vimPlugins, buildVimPluginFrom2Nix, fetchFromGitHub, xdgConfigHome
, xdgDataHome, xdgCacheHome }:

let
  xuyuanp-nerdtree-git-plugin = buildVimPluginFrom2Nix rec {
    pname = "nerdtree-git-plugin";
    version = "2021-08-18";
    src = fetchFromGitHub {
      owner = "Xuyuanp";
      repo = pname;
      rev = "e1fe727127a813095854a5b063c15e955a77eafb";
      sha256 = "H3IxxQwz3Q1nO7oSDKCtoGCsoPDWO3jRjqtwp3Kp/TQ=";
    };
    meta.homepage = "https://github.com/Xuyuanp/nerdtree-git-plugin/";
  };
in {
  enable = true;
  defaultEditor = true;

  settings = {
    number = true;
    relativenumber = true;
    ignorecase = true;
    smartcase = true;
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
    mouse = "a";
    undodir = [ "${xdgCacheHome}/vim/undo" ];
    directory = [ "${xdgCacheHome}/vim/swap" ];
    backupdir = [ "${xdgCacheHome}/vim/backup" ];
  };

  # For an explanation of all these options, see the .vimrc in this repository
  extraConfig = ''
    set nocompatible

    augroup numbertoggle
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
    augroup END

    set backspace=indent,eol,start

    set encoding=utf-8

    set viewdir=${xdgDataHome}/vim/view
    set viminfo+='1000,n${xdgCacheHome}/vim/viminfo

    call mkdir(&undodir, 'p')
    call mkdir(&directory, 'p')
    call mkdir(&backupdir, 'p')
    call mkdir(&viewdir, 'p')

    set wildmode=longest,list,full

    colorscheme koehler
    autocmd BufRead,BufNewFile *.zsh* set syntax=zsh

    set hlsearch incsearch
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

    set softtabstop=0
    autocmd BufRead,BufNewFile *.nix,*.zsh*,*.yaml set tabstop=2 shiftwidth=2

    set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
    nnoremap <silent> <C-l> :set list!<CR>

    if !exists(':DiffOrig')
      command DiffOrig vert new | set bt=nofile | r ++edit
        \ | wincmd p | diffthis
    endif

    set scrolloff=5

    autocmd StdinReadPre * let s:std_in = 1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    nmap <C-n> :NERDTreeToggle<CR>

    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    let NERDTreeShowHidden = 1
    let g:NERDTreeGitStatusUseNerdFonts = 1
    let g:NERDTreeGitStatusConcealBrackets = 1

    set updatetime=300
    highlight! link SignColumn LineNr
    let g:gitgutter_set_sign_backgrounds = 1

    let g:coc_config_home = '~/.config/coc'

    inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

    inoremap <silent><expr> <C-n> coc#refresh()
  '';

  plugins = with vimPlugins; [
    vim-toml
    nerdtree
    xuyuanp-nerdtree-git-plugin
    coc-nvim
    vim-gitgutter
    vim-nix
  ];
}
