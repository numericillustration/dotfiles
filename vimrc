set nocp
execute pathogen#infect()
filetype on
filetype plugin on
filetype indent on
syntax enable
set ruler
set number
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" recovery dir in case the box crashes
set directory=~/.vim/tmp

" the way I used to do backup files
"set backupdir=~/.vim/backup
"set backup
"set writebackup


let vimDir = '$HOME/.vim'  
set autowrite                                                                   
set updatecount=10                                                              
if has('persistent_undo')                                                       
    let myUndoDir = expand(vimDir . '/undo')                                    
    " Create dirs                                                               
    call system('mkdir ' . vimDir)                                              
    call system('mkdir ' . myUndoDir)                                           
    let &undodir = myUndoDir                                                    
    set undolevels=5000                                                         
    set undofile                                                                
endif     



set magic
set wildmode=longest:full,full " enables bash-like autocomplete for commands

" in case I want to disable folding
"set nofoldenable 
"set foldminlines=99999
"set fdm=indent
" yes even during diff
"let g:vim_markdown_folding_disabled=1
set diffopt=filler,context:1000000 " filler is default and inserts empty lines for sync
if &diff
    "disable folding
    set diffopt=filler,context:1000000
endif

set matchpairs+=<:>               "Allow % to bounce between angles too
set backspace=indent,eol,start    "Make backspaces delete sensibly
set shiftround                    "Indent/outdent to nearest tabstop

" stuff I used to use from Perl Best Practices when I wrote perl all day every day
"Inserting these abbreviations inserts the corresponding Perl statement...
"iab phbp  #! /usr/bin/perl -w      
"iab pdbg  use Data::Dumper 'Dumper';warn Dumper [];hi
"iab pbmk  use Benchmark qw( cmpthese );cmpthese -10, {};O     
"iab pusc  use Smart::Comments;### 
"iab putm  use Test::More qw( no_plan );
" 
"iab papp  :r ~/.vim/code_templates/perl_app_template.pl
"iab pmod  :r ~/.vim/code_templates/perl_mod_template.pm
" END from PBP - trying out


" say what? are these?
set splitbelow
set splitright
set incsearch
set hlsearch

let Tlist_Ctags_Cmd = '/opt/pkg/bin/exctags'

if has('gui_running')
  set guioptions-=T  " no toolbar
  set transparency=3
endif

set background=dark
let g:solarized_termcolors=   256
let g:solarized_termtrans =   1
let g:solarized_degrade   =   1
"let g:solarized_bold      =   0
"let g:solarized_underline =   0
"let g:solarized_italic    =   0
"let g:solarized_contrast  =   "high"
"let g:solarized_visibility=   "high"
colorscheme solarized

let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=white
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgrey


" Status line stuff
set laststatus=2

hi User1 ctermbg=lightblue ctermfg=black   guibg=#af8700 guifg=#262626
hi User2 ctermbg=red   ctermfg=blue  guibg=#657b83   guifg=#262626
hi User3 ctermbg=blue  ctermfg=green guibg=DarkGray  guifg=#262626

set statusline=%1*                             " use User1 colorscheme
set statusline+=%F                             " full filename
set statusline+=%2*                            " use User2 colorscheme
set statusline+=%m                             " modified flag set? shows [-] or [+]
set statusline+=%r                             " read only flag set? shows [RO]
set statusline+=%h                             " help file flag? shows [help]
set statusline+=%w                             " preview window flag?
set statusline+=%=                             " right justify the rest
set statusline+=\ [Format:\ %{&ff}]            " file format
set statusline+=\ [Filetype:\ %Y]              " filetype
set statusline+=\ [ASCII:\ %03.3b]             " ascii code for char under cursor
set statusline+=\ [HEX:\ %02.2B]               " hex for char under cursor
set statusline+=\ [Position\ r,c:\ %04l,%04v]  " cursor posistion line/column
set statusline+=\ [Progress:\ %02p%%]          " cursor percent of way through file
set statusline+=%3*                            " use User3 colorscheme
set statusline+=\ [Length=%L]                  " File length in line


" no more searched landing on the bottom, center that stuff in my window!
nnoremap n nzz
nnoremap } }zz

cmap vs vertical split 
cmap vd vertical diffsplit 

cmap w!! w !sudo tee % >/dev/null

" Mapping of keys to insetion of comments for various types of files
" , #perl and conf # comments
map ,# :s/^/#/<CR>:s/\\\<CR>

" insert a whole line of hashes
map ,## :s/^/######################################################################/<CR>

" ,/ C/C++/C#/Java // comments
map ,/ :s/^/\/\//<CR>

" ,< HTML comment
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>

" c++ java style comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>
