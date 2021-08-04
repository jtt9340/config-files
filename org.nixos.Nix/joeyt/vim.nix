# Configuation settings for Vim
{ vimPlugins
, buildVimPluginFrom2Nix
, fetchFromGitHub
, xdgConfigHome
, xdgDataHome
, xdgCacheHome
}:

let
  xuyuanp-nerdtree-git-plugin = buildVimPluginFrom2Nix rec {
    pname = "nerdtree-git-plugin";
    version = "2020-12-05";
    src = fetchFromGitHub {
      owner = "Xuyuanp";
      repo = pname;
      rev = "5fa0e3e1487b17f8a23fc2674ebde5f55ce6a816";
      sha256 = "0nwb3jla0rsg9vb52n24gjis9k4fwn38iqk13ixxd6w5pnn8ax9j";
    };
    meta.homepage = "https://github.com/Xuyuanp/nerdtree-git-plugin/";
  };
in {
  enable = true;

  settings = {
    number = true;
    relativenumber = true;
    smartcase = true;
    undodir = [ "${xdgCacheHome}/vim/undo" ];
    directory = [ "${xdgCacheHome}/vim/swap" ];
    backupdir = [ "${xdgCacheHome}/vim/backup" ];
  };

  # For an explanation of all these options, see the .vimrc in this repository
  extraConfig = ''
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

    set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
    autocmd BufRead,BufNewFile *.nix,*.zsh*,*.yaml set tabstop=2 softtabstop=0 expandtab shiftwidth=2
    autocmd BufRead,BufNewFile *.py set expandtab
    
    set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
    nnoremap <silent> <C-l> :set list!<CR>

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
  '';

  plugins = with vimPlugins; [
    vim-toml
    nerdtree
    xuyuanp-nerdtree-git-plugin
    vim-gitgutter
    vim-nix
  ];
}
