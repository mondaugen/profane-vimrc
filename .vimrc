
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
function! s:Insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>Insert_gates()

" header gates once in file, type: <Esc>:call g:hdrgt()
function! g:Hdrgt()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction

" an #ifdef __cplusplus gate
function! g:Cppdfgt()
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
function! g:Rjdfbs()
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
map ,rjc :call g:Rjdfbs()<CR>
" right justify last character
map ,rjlc @="$:call g:Rjdfbs()\rj"<CR>

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

function! s:Insert_html_skeleton()
  execute "normal! i<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv='Content-Type' "
  execute "normal! i content='text/html:charset=utf-8' />\n</head>\n<body>\n</body>\n</html>"
  execute "normal! gg=G"
endfunction
autocmd BufNewFile *.{htm,html} call <SID>Insert_html_skeleton()

" Toggle relative number
function! RNU_toggle()
    if(&relativenumber == 1)
        se nornu
    else
        se rnu
    endif
endfun

map ,rn :call RNU_toggle()<CR>
" Set font
se guifont=Menlo\ 10

" Set line breaking
se wrap
se lbr

" Set colour scheme, budday
colo koehler

" Map CTRL-S to :w
map  :w
" Map CTRL-N to :
map  :

" Map CTRL-T to CTRL-I to do indenting
inoremap <C-I> <C-T>
" Unmap or else it will indent whole line
iunmap <Tab>
" Map CTRL-T to do readline style character swaps
inoremap <C-T> hxpa 

" Map N so that it centres the window when searching
nnoremap n nzz
nnoremap N Nzz
" Map CTRL-E differently in insert mode
" Deletes until a character is found
inoremap <C-E> <Nop>
inoremap <C-E><C-E> <Esc>d;i<Right><BS>
inoremap <C-E>` <Esc>dF`i<Right><BS>
inoremap <C-E>~ <Esc>dF~i<Right><BS>
inoremap <C-E>1 <Esc>dF1i<Right><BS>
inoremap <C-E>! <Esc>dF!i<Right><BS>
inoremap <C-E>2 <Esc>dF2i<Right><BS>
inoremap <C-E>@ <Esc>dF@i<Right><BS>
inoremap <C-E>3 <Esc>dF3i<Right><BS>
inoremap <C-E># <Esc>dF#i<Right><BS>
inoremap <C-E>4 <Esc>dF4i<Right><BS>
inoremap <C-E>$ <Esc>dF$i<Right><BS>
inoremap <C-E>5 <Esc>dF5i<Right><BS>
inoremap <C-E>% <Esc>dF%i<Right><BS>
inoremap <C-E>6 <Esc>dF6i<Right><BS>
inoremap <C-E>^ <Esc>dF^i<Right><BS>
inoremap <C-E>7 <Esc>dF7i<Right><BS>
inoremap <C-E>& <Esc>dF&i<Right><BS>
inoremap <C-E>8 <Esc>dF8i<Right><BS>
inoremap <C-E>* <Esc>dF*i<Right><BS>
inoremap <C-E>9 <Esc>dF9i<Right><BS>
inoremap <C-E>( <Esc>dF(i<Right><BS>
inoremap <C-E>0 <Esc>dF0i<Right><BS>
inoremap <C-E>) <Esc>dF)i<Right><BS>
inoremap <C-E>- <Esc>dF-i<Right><BS>
inoremap <C-E>_ <Esc>dF_i<Right><BS>
inoremap <C-E>= <Esc>dF=i<Right><BS>
inoremap <C-E>+ <Esc>dF+i<Right><BS>
inoremap <C-E>q <Esc>dFqi<Right><BS>
inoremap <C-E>Q <Esc>dFQi<Right><BS>
inoremap <C-E>w <Esc>dFwi<Right><BS>
inoremap <C-E>W <Esc>dFWi<Right><BS>
inoremap <C-E>e <Esc>dFei<Right><BS>
inoremap <C-E>E <Esc>dFEi<Right><BS>
inoremap <C-E>r <Esc>dFri<Right><BS>
inoremap <C-E>R <Esc>dFRi<Right><BS>
inoremap <C-E>t <Esc>dFti<Right><BS>
inoremap <C-E>T <Esc>dFTi<Right><BS>
inoremap <C-E>y <Esc>dFyi<Right><BS>
inoremap <C-E>Y <Esc>dFYi<Right><BS>
inoremap <C-E>u <Esc>dFui<Right><BS>
inoremap <C-E>U <Esc>dFUi<Right><BS>
inoremap <C-E>i <Esc>dFii<Right><BS>
inoremap <C-E>I <Esc>dFIi<Right><BS>
inoremap <C-E>o <Esc>dFoi<Right><BS>
inoremap <C-E>O <Esc>dFOi<Right><BS>
inoremap <C-E>p <Esc>dFpi<Right><BS>
inoremap <C-E>P <Esc>dFPi<Right><BS>
inoremap <C-E>[ <Esc>dF[i<Right><BS>
inoremap <C-E>{ <Esc>dF{i<Right><BS>
inoremap <C-E>] <Esc>dF]i<Right><BS>
inoremap <C-E>} <Esc>dF}i<Right><BS>
inoremap <C-E>\ <Esc>dF\i<Right><BS>
inoremap <C-E>a <Esc>dFai<Right><BS>
inoremap <C-E>A <Esc>dFAi<Right><BS>
inoremap <C-E>s <Esc>dFsi<Right><BS>
inoremap <C-E>S <Esc>dFSi<Right><BS>
inoremap <C-E>d <Esc>dFdi<Right><BS>
inoremap <C-E>D <Esc>dFDi<Right><BS>
inoremap <C-E>f <Esc>dFfi<Right><BS>
inoremap <C-E>F <Esc>dFFi<Right><BS>
inoremap <C-E>g <Esc>dFgi<Right><BS>
inoremap <C-E>G <Esc>dFGi<Right><BS>
inoremap <C-E>h <Esc>dFhi<Right><BS>
inoremap <C-E>H <Esc>dFHi<Right><BS>
inoremap <C-E>j <Esc>dFji<Right><BS>
inoremap <C-E>J <Esc>dFJi<Right><BS>
inoremap <C-E>k <Esc>dFki<Right><BS>
inoremap <C-E>K <Esc>dFKi<Right><BS>
inoremap <C-E>l <Esc>dFli<Right><BS>
inoremap <C-E>L <Esc>dFLi<Right><BS>
inoremap <C-E>; <Esc>dF;i<Right><BS>
inoremap <C-E>: <Esc>dF:i<Right><BS>
inoremap <C-E>' <Esc>dF'i<Right><BS>
inoremap <C-E>" <Esc>dF"i<Right><BS>
inoremap <C-E>z <Esc>dFzi<Right><BS>
inoremap <C-E>Z <Esc>dFZi<Right><BS>
inoremap <C-E>x <Esc>dFxi<Right><BS>
inoremap <C-E>X <Esc>dFXi<Right><BS>
inoremap <C-E>c <Esc>dFci<Right><BS>
inoremap <C-E>C <Esc>dFCi<Right><BS>
inoremap <C-E>v <Esc>dFvi<Right><BS>
inoremap <C-E>V <Esc>dFVi<Right><BS>
inoremap <C-E>b <Esc>dFbi<Right><BS>
inoremap <C-E>B <Esc>dFBi<Right><BS>
inoremap <C-E>n <Esc>dFni<Right><BS>
inoremap <C-E>N <Esc>dFNi<Right><BS>
inoremap <C-E>m <Esc>dFmi<Right><BS>
inoremap <C-E>M <Esc>dFMi<Right><BS>
inoremap <C-E>, <Esc>dF,i<Right><BS>
inoremap <C-E>< <Esc>dF<i<Right><BS>
inoremap <C-E>. <Esc>dF.i<Right><BS>
inoremap <C-E>> <Esc>dF>i<Right><BS>
inoremap <C-E>/ <Esc>dF/i<Right><BS>
inoremap <C-E>? <Esc>dF?i<Right><BS>

" Source site vimrc
if filereadable($HOME . "/.vimrc_local")
    so $HOME/.vimrc_local
endif

" Start pathogen if exists
if filereadable($HOME . "/.vim/autoload/pathogen.vim")
    execute pathogen#infect()
    let g:vim_markdown_folding_disabled = 1
endif
