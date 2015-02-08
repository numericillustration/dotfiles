set nocp
filetype on
filetype plugin on
filetype indent on
syntax enable
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set directory=~/.vim/tmp
set backupdir=~/.vim/backup

set backup
set writebackup

" BEGIN from PBP - trying out
set matchpairs+=<:>               "Allow % to bounce between angles too
set backspace=indent,eol,start    "Make backspaces delete sensibly
set shiftround                    "Indent/outdent to nearest tabstop
"Inserting these abbreviations inserts the corresponding Perl statement...
iab phbp  #! /usr/bin/perl -w      
iab pdbg  use Data::Dumper 'Dumper';warn Dumper [];hi
iab pbmk  use Benchmark qw( cmpthese );cmpthese -10, {};O     
iab pusc  use Smart::Comments;### 
iab putm  use Test::More qw( no_plan );
 
iab papp  :r ~/.vim/code_templates/perl_app_template.pl
iab pmod  :r ~/.vim/code_templates/perl_mod_template.pm
" END from PBP - trying out

set ruler
set laststatus=2
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"trying out Gautam's status line
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
set magic
set wildmode=longest,list
set splitbelow
set splitright
set incsearch
set hlsearch
" Omni completion enabler
"set ofu=syntaxcomplete#Complete
execute pathogen#infect()

let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

if has('gui_running')
  set guioptions-=T  " no toolbar
  set transparency=5
endif

set background=dark
let g:solarized_termcolors=   256
let g:solarized_termtrans =   1
let g:solarized_degrade   =   1
let g:solarized_bold      =   0
let g:solarized_underline =   0
let g:solarized_italic    =   0
let g:solarized_contrast  =   "high"
let g:solarized_visibility=   "high"
colorscheme solarized



let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=white
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgrey

set number
"set foldenable
"set fdm=indent


" no more landing on the bottom, center that yo!
nnoremap n nzz
nnoremap } }zz

cmap vs vertical split 
cmap vd vertical diffsplit 

cmap w!! w !sudo tee % >/dev/null

" Mapping of keys to insetion of comments for various types of files
" , #perl # comments
map ,# :s/^/#/<CR>:s/\\\<CR>

" ,/ C/C++/C#/Java // comments
map ,/ :s/^/\/\//<CR>

" ,< HTML comment
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>

" c++ java style comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>


map ,## :s/^/######################################################################/<CR>
map ,- :s/^/-- /<CR>
