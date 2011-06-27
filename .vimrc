syntax on

" Color Settings
set t_Co=256
set nocompatible

" Tabbing Settings
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" Misc
set incsearch
set encoding=utf8
set ignorecase
set wrap!
"set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Various Maps
map <c-p> :set paste<cr>i
"set mouse=a
cmap WW w !sudo tee %
map <c-r> :tabnext<CR>
map <c-e> :tabprevious<CR>
map <c-n> :tabnew<CR>
map <c-c> :tabclose<CR>
map nt :NERDTreeToggle<CR>
"map df :set filetype=diff<CR>
cmap CSV :%ArrangeCol<CR>

colorscheme jellybeans

if has("autocmd")
    " Enable file type detection
    filetype on
    filetype plugin on

    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml 

    " Automatically syntax check ruby files
    au BufWritePost *.rb !ruby -c %

    " Restore cursor position and set line
     autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
 
    augroup filetypedetect
      " Mail
      autocmd BufRead,BufNewFile *mutt-* setfiletype mail
    augroup END
endif

let g:Gitv_OpenHorizontal = 1
let g:Gitv_WipeAllOnClose = 1
