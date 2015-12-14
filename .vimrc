
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" NO SWAP FILE
set noswapfile

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
"set nowrapping
set nowrap
"set line wrapping
set textwidth=80
" number lines
set number

" Set tab width to 4
set ts=4
" Insert spaces when tab key pressed
set expandtab
set smarttab
set shiftwidth=4

"edit vimrc
map ,ev :tabe $MYVIMRC<CR>

"system header tags
set tags+=~/.vim/systags

"quick lhs comments
map ,# :s/^/#/<CR> <Esc>:nohlsearch <CR>
map ,/ :s/^/\/\//<CR> <Esc>:nohlsearch <CR>
map ,> :s/^/> /<CR> <Esc>:nohlsearch<CR>
map ," :s/^/\"/<CR> <Esc>:nohlsearch<CR>
map ,% :s/^/%/<CR> <Esc>:nohlsearch<CR>
map ,! :s/^/!/<CR> <Esc>:nohlsearch<CR>
map ,; :s/^/;/<CR> <Esc>:nohlsearch<CR>
map ,- :s/^/--/<CR> <Esc>:nohlsearch<CR>
map ,c :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR> <Esc>:nohlsearch<CR>

" quick wrapping comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR> <Esc>:nohlsearch<CR>
map ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR><Esc>:nohlsearch <CR>
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR> <Esc>:nohlsearch<CR>
map ,d :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR> <Esc>:nohlsearch<CR>

" quick nohighlighted search
map ,nh <Esc>:nohlsearch<CR>

" underline text
nnoremap ,ul yyp<c-v>$r-
nnoremap ,UL yyp<c-v>$r-

" spell checking
map ,sp <Esc>:setlocal spell spelllang=en_us<CR>

""""""" C STUFF """""""

" quick headerfile function prototypes
" put your cursor at the beginning of a function comment
" execute this command. you will be prompted for a headerfile you want to append
" to. type it in and your function prototype will be appended
map ,hfp :.,/{/-1w>>
" quick #define
map ,df :s/^/#define /<CR>A <Esc>:nohls<CR>i
" quick #include
map ,in :s/^/#include /<CR>A <Esc>:nohls<CR>i
" quick #ifdef
map ,ifd :s/^/#ifdef /<CR>A <Esc>:nohls<CR>i
" quick #ifndef
map ,ifn :s/^/#ifndef /<CR>A <Esc>:nohls<CR>i
" quick #undef
map ,ud :s/^/#undef /<CR>A <Esc>:nohls<CR>i
" quick #else
map ,el :s/^/#else /<CR>A <Esc>:nohls<CR>i
" quick #endif
map ,ef :s/^/#endif /<CR>A <Esc>:nohls<CR>i

" automatic header gates when opening file
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" header gates once in file, type: <Esc>:call g:hdrgt()
function! g:hdrgt()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction

" an #ifdef __cplusplus gate
function! g:cppdfgt()
    execute "normal! i#undef __BEGIN_DECLS\n"
    execute "normal! i#undef __END_DECLS\n"
    execute "normal! i#ifdef __cplusplus\n"
    execute "normal! i# define  __BEGIN_DECLS extern \"C\" {\n"
    execute "normal! i# define  __END_DECLS }\n"
    execute "normal! i#else  \n"
    execute "normal! i# define  __BEGIN_DECLS /* empty */\n"
    execute "normal! i# define  __END_DECLS /* empty */\n"
    execute "normal! i#endif\n"
    execute "normal! i__BEGIN_DECLS\n"
    execute "normal! i__END_DECLS\n"
endfunction

" move a backslash to the furthest right column (for #define ... \ constructs)
function! g:rjdfbs()
    let b:indtamt = &tw - virtcol(".") - 1
    let i = 0
    while i < b:indtamt
	execute "normal i \<Esc>"
	let i=i+1
    endwhile
    unlet b:indtamt
    unlet i
endfunction
" right justify character
map ,rjc :call g:rjdfbs()<CR>
" right justify last character
map ,rjlc @="$:call g:rjdfbs()\rj"<CR>

"if has("vms")
set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
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

  " For all text files wrap lines based on size of window
  autocmd FileType text setlocal textwidth=0
  autocmd FileType text setlocal wrapmargin=0
  autocmd FileType text setlocal wrap
  autocmd FileType text setlocal linebreak
  autocmd FileType text setlocal nolist
  

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

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

function! s:insert_html_skeleton()
  execute "normal! i<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv='Content-Type' "
  execute "normal! i content='text/html:charset=utf-8' />\n</head>\n<body>\n</body>\n</html>"
  execute "normal! gg=G"
endfunction
autocmd BufNewFile *.{htm,html} call <SID>insert_html_skeleton()

" Set font
se guifont=Menlo\ 9 

" Set line breaking
se wrap
se lbr

" Set colour scheme, budday
colo darkblue
