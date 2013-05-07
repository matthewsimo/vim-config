" Maintainer:	Matthew Simo <matthew.a.simo@gmail.com>


" ========================================
" General Set up
" ========================================

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  " always set autoindenting on
  set autoindent		

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Call pathogen
call pathogen#infect()


" ========================================
" Personal Settings
" ========================================


" Set where backups go
set backupdir=~/.vim/backup

set noswapfile


" Personal flavor

set number
set hidden

" Indents
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable
set cmdheight=2

filetype plugin on
filetype indent on

set nowrap
set magic
set showmatch
set noerrorbells
set incsearch
set hlsearch

" Scrolling
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" Toggle Paste Mode & auto unset when leaving insert mode
map <Leader>p :set invpaste<CR>:set paste?<CR>
set pastetoggle=<Leader>p
au InsertLeave * set nopaste

" syntax highlighting & solarized config
syntax on
let &t_Co=256
let g:solarized_degrade=0
let g:solarized_italic=1
let g:solarized_bold=1
let g:solarized_underline=1
colorscheme solarized
set background=dark


" Set sign column clear
highlight clear SignColumn


" Default Cursor line in current window only.
set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


" Nerd Tree
autocmd vimenter * if !argc() | NERDTree | endif


" Command mode completion
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif


" Set GitGutter on!
let g:gitgutter_enabled = 1


" Define Map Leader
:let mapleader = "-"


" Remember info about open buggers on close
set viminfo^=%


" Disable lint
:let disable_lint = 1


set laststatus=2
let g:Powerline_symbols='fancy'
let g:Powerline_theme='skwp'
let g:Powerline_colorscheme='skwp'

:set nopaste
" Match settings
set matchpairs+=<:>     " specially for html

let g:UltiSnipsSnippetsDir="~/.vim/bundle/ultisnips/Ultisnips"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]
let g:UltiSnipsListSnippets ="<s-space>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


  
" ========================================
" Utility Functions & Custom Commands
" ========================================


" Highlight trailing white space for find/replace
func! DeleteTrailingWS()
  %s/\s\+$//e
endfunc


" Reset current search
command! C let @/=""


" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" Visual * - Search for selected text * = next # = prev
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


" ========================================
" Custom Mappings
" ========================================


" Quick Edit for .vimrc
:nnoremap <leader>ev :split $MYVIMRC<cr>


" Source Vim
:nnoremap <leader>sv :source $MYVIMRC<cr>


" Edit Snippets for this file type
:nnoremap <leader>es :UltiSnipsEdit<cr>


" Map some keys for easier tab usage
map <S-h> :tabfirst<CR>
map <S-j> :tabprevious<CR>
map <S-k> :tabnext<CR>
map <S-l> :tablast<CR>


" Map for nerd tree - to control n in normal mode
nmap <silent> <c-n> :NERDTreeToggle<CR>


" Map for Search/Replate Trailing White space
:nnoremap <leader>ws :call DeleteTrailingWS()<CR>

" Toggle GitGutter
:nnoremap <leader><Tab> :ToggleGitGutter<CR>

" Toggle GitGutter line highlighting
:nnoremap <leader>hl :ToggleGitGutterLineHighlights<CR>

" GitGutter Next hunk ~ hubba hubba
:nnoremap <leader>n :GitGutterNextHunk<CR>

" GitGutter prev hunk
:nnoremap <leader>N :GitGutterPrevHunk<CR>

" ========================================
" Custom Abbreviations
" ========================================


