
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
"removed many that I never use
map ,# 0i#
map ,/ ^i//
"map ,> :s/^/> /<CR> <Esc>:nohlsearch<CR>
map ," 0i"
map ,% 0i%
"map ,! :s/^/!/<CR> <Esc>:nohlsearch<CR>
"map ,; :s/^/;/<CR> <Esc>:nohlsearch<CR>
"map ,- :s/^/--/<CR> <Esc>:nohlsearch<CR>
"map ,c :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR> <Esc>:nohlsearch<CR>

" quick wrapping comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR> <Esc>:nohlsearch<CR>
"map ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR><Esc>:nohlsearch <CR>
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR> <Esc>:nohlsearch<CR>
"map ,d :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR> <Esc>:nohlsearch<CR>

" quick nohighlighted search
map ,nh <Esc>:nohlsearch<CR>

" underline text
nnoremap ,ul yyp<c-v>$r-
nnoremap ,UL yyp<c-v>$r-

" spell checking
map ,sp <Esc>:setlocal spell spelllang=en_us<CR>

" C STUFF

" quick headerfile function prototypes
" put your cursor at the beginning of a function comment
" execute this command. you will be prompted for a headerfile you want to append
" to. type it in and your function prototype will be appended
nmap ,hfp :.,/{/-1w>>
" quick #define
nmap ,df 0i#define 
" quick #include
nmap ,in 0i#include 
" quick #ifdef
nmap ,ifd 0i#ifdef 
" quick #ifndef
nmap ,ifn 0i#ifndef 
" quick #undef
nmap ,ud 0i#undef 
" quick #else
nmap ,el 0i#else 
" quick #endif
nmap ,ef 0i#endif 

" automatic header gates when opening file
function! s:Insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  let gatename = substitute(gatename, "-", "_", "g")
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
nmap  :w
imap  :w
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

" Split line in normal mode using K
nmap K m'a<CR><Esc>`'

" Redraw syntax highlighting
map ,ss <Esc>:syntax sync fromstart<CR>

" Resize to 88 columns (80 columns text)
nmap ,cc <Esc>:se columns=88<CR>

" Source site vimrc
if filereadable($HOME . "/.vimrc_local")
    so $HOME/.vimrc_local
endif

" Start pathogen if exists
if filereadable($HOME . "/.vim/autoload/pathogen.vim")
    execute pathogen#infect()
    let g:vim_markdown_folding_disabled = 1
endif

" Number tab titles
set showtabline=0 " don't show tab lines by default
" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name
  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')
  return label . '  [' . wincount . ']'
endfunction
set guitablabel=%{GuiTabLabel()}
nmap ,gt <Esc>:set guitablabel=%{GuiTabLabel()}<CR>

"" Display 'word' indices in the status line and supply functions for jumping to
"" these words
"" Cannot yet be combined with yanking etc., only for cursor movement.

" Get the indices of words on the current line
function! g:GetWordIndices()
    let idcs=[]
    let line=getline('.')
    let mtchcnt=1
    let curmch=match(line,'\<\k\+',0,mtchcnt)
" Adjust for width of tabs
    if (curmch != -1)
        let curmch = strdisplaywidth(line[0:curmch-1])
    endif
    while (curmch != -1)
        let idcs += [curmch]
        let mtchcnt += 1
        let curmch=match(line,'\<\k\+',0,mtchcnt)
" Adjust for width of tabs
        if (curmch != -1)
            let curmch = strdisplaywidth(line[0:curmch-1])
        endif
    endwhile
    return idcs
endfunction

" Jump to the nth match of GetWordIndices where 1 is the first, 2 is the second
" etc.
function! g:GoToNthWord(nth)
    if (a:nth < 1)
        return
    endif
    let idcs=g:GetWordIndices()
    if (a:nth > len(idcs))
        return
    endif
    execute "normal " . (idcs[a:nth - 1] + 1) . "|"
endfunction

function! g:GoToAdjWord(arg,dir)
    let arg = a:arg
    if (a:arg == 0)
        let arg = 1
    endif
    let vc = virtcol('.') - 1
    let wi = g:GetWordIndices()
    if len(wi) <= 0
        return
    endif
    let mc = 0
    if (a:dir == 0)
        " going backwards
        let i = len(wi)
        if vc <= wi[0]
            let i = 0
        endif
        while ((i - 1) >= 0) && (wi[i-1] >= vc)
            let i -= 1
        endwhile
        if (i <= 0)
            " can't move back
            return
        elseif i == len(wi)
            " Written this way for clarity
            " Move to index of last word plus argument - 1 (so argument of 1
            " simply moves to the index)
            let idx = -1 - (arg - 1)
            let mc = wi[idx]
        else
            let idx = i - arg
            let mc = wi[idx]
        endif
    else
        " going forwards
        let i = -1
        if vc >= wi[-1]
            let i = len(wi) - 1
        endif
        while ((i + 1) < len(wi)) && (wi[i+1] <= vc)
            let i += 1
        endwhile
        if (i >= (len(wi) - 1))
            " can't move forward
            return
        elseif i == -1
            " Written this way for clarity
            " Move to index of first word plus argument - 1 (so argument of 1
            " simply moves to the index)
            let idx = 0 + (arg - 1)
            let mc = wi[idx]
        else
            let idx = i + arg
            let mc = wi[idx]
        endif
    endif
    execute "normal " . (mc + 1) . "|"
endfunction        

function! g:ShowWords(cols)
    let idcs=g:GetWordIndices()
    let imax=max(idcs)
    "echo imax
    let strl=[]
    " increment imax by the string length of the last idcs index number
    let imax += strlen(printf('%d',len(idcs)+1))
    while (imax >= 0)
        let strl += ['-']
        let imax -= 1
    endwhile
    let l = len(idcs)
    let l -= 1
    while (l >= 0)
        let numstr = printf('%d',l+1)
        let lstr = strlen(numstr)
        while (lstr > 0)
            let lstr -= 1
            let strl[idcs[l] + lstr] = numstr[lstr]
        endwhile
        let l -= 1
    endwhile
    " Set status line to show word numbers
    let str=join(strl,'')
    let numw=wincol()-virtcol('.')
    let prep=''
    while (numw > 0)
        let prep = prep . '-'
        let numw -= 1
    endwhile
    execute 'setlocal statusline=' . prep . str
    " Colour columns, too
    if (a:cols != 0)
        let ccols=''
        let l = len(idcs) - 1
        while (l >= 0) 
            let ccols=ccols . printf("%d",idcs[l] + 1) . ','
            let l = l - 1
        endwhile
        execute 'setlocal colorcolumn=' . ccols[:-2]
    endif

endfunction

function! g:CountTest(cnt)
    echo printf('%d',a:cnt)
endfunction

function! g:RegisterWordJumpCntFuncs(cols)
    " This doesn't work as expected because laststatus cannot be set locally
"    let b:RegisterWordJumpCntFuncs_lastlaststatus=&laststatus
    setlocal laststatus=2
    augroup wordJumpCntFuncs
        " remove all commands
        au! * <buffer>
        if (a:cols==0)
            au! CursorMoved <buffer> call g:ShowWords(0)
            call g:ShowWords(0)
        else
            au! CursorMoved <buffer> call g:ShowWords(1)
            call g:ShowWords(1)
        endif
    augroup END
endfunction

function! g:RemoveWordJumpCntFuncs(col)
"    execute 'setlocal laststatus=' . b:RegisterWordJumpCntFuncs_lastlaststatus
    setlocal laststatus=0
    au! wordJumpCntFuncs * <buffer>
endfunction

nmap ,rwj :<C-U>call g:RegisterWordJumpCntFuncs(0)<CR>
nmap ,rnwj :<C-U>call g:RemoveWordJumpCntFuncs(0)<CR>
" I never use ~ for original purpose so unmap it
nnoremap ~ <NOP>
nmap <silent> ~ :<C-U>call g:GoToNthWord(v:count)<CR>
nnoremap <silent> ,w :<C-U>call g:GoToAdjWord(v:count,1)<CR>
nnoremap <silent> ,b :<C-U>call g:GoToAdjWord(v:count,0)<CR>

" Optionally if you don't like the status line
" :hi StatusLine guibg=darkblue guifg=white
" :hi StatusLineNC guifg=black guibg=darkblue

" Map ,, to ,
noremap ,, ,
" I also never use _ so this can be mapped
noremap _ ,

" Remove increment and decrement
map <C-A> <NOP>
map <C-X> <NOP>

" Map :marks to CTRL-M (disables calling + command)
nnoremap <C-M> <Esc>:marks<CR>

" Allow hidden buffers
se hidden

"List buffers
nmap  <C-L>b :buffers<CR>
"List changes
nmap  <C-L>c :changes<CR> 
"List jumps
nmap  <C-L>j :jumps<CR>
"List sections (useful for latex files)
nmap <C-L>s :let x=system("grep -n section " . expand("%") . " \| sort -n") \| echo x<CR>

"List functions in c
autocmd BufRead,BufNewFile *.{h,hpp,c,cpp,cc} nmap <C-L>f :let x=system("ctags -x --c-kinds=fp --c++-kinds=fpx -I" . expand("~/") . ".profane/ctags-id-list " . expand("%") . " \| awk '{$1=\"\";$2=\"\";$4=\"\";print $0}' \| sort -n") \| echo x<CR>

"List structures, classes and members in c
autocmd BufRead,BufNewFile *.{h,hpp,c,cpp,cc} nmap <C-L>S :let x=system("ctags -x --c-kinds=cms --c++-kinds=cms -I" . expand("~/") . ".profane/ctags-id-list " . expand("%") . " \| awk '{$1=\"\";$2=\"\";$4=\"\";print $0}' \| sort -n") \| echo x<CR>

"List functions in c, a bit janky but lets you search for strings
autocmd BufRead,BufNewFile *.{h,hpp,c,cpp,cc} nmap <C-L>F :!ctags -x --c-kinds=fp --c++-kinds=fpx -I~/.profane/ctags-id-list <C-R>% \| awk '{$1="";$2="";$4="";print $0 }' \| sort -n \|less<CR>

"List functions in Perl
autocmd BufRead,BufNewFile *.{pl,perl} nmap <C-L>f :let x=system("ctags -x --perl-kinds=sd " . expand("%") . " \| awk '{$1=\"\";$2=\"\";$4=\"\";print $0}' \| sort -n") \| echo x<CR>

"List functions in Python
autocmd BufRead,BufNewFile *.{py} nmap <C-L>f :let x=system("ctags -x --python-kinds=f " . expand("%") . " \| awk '{$1=\"\";$2=\"\";$4=\"\";print $0}' \| sort -n") \| echo x<CR>

autocmd BufRead,BufNewFile *.vimrc,*.{vim} nmap <C-L>f :let x=system("ctags -x --vim-kinds=fc " . expand("%") . " \| awk '{$1=\"\";$2=\"\";$4=\"\";print $0}' \| sort -n") \| echo x<CR>

"List functions in OpenSCAD
autocmd BufRead,BufNewFile *.{scad} nmap <C-L>f :let x=system("grep -n -e module -e function " . expand("%")) \| echo x<CR>

"List tabs
nmap <C-L>t :tabs<CR>

" Set dictionary file if exists
if filereadable("/usr/share/dict/words")
    set dictionary=/usr/share/dict/words
endif

" Print current file
nnoremap ,cf <Esc>:echo @%<CR>

" move forward in insert mode without arrow keys
imap <C-F> <C-O>l

" move backward in insert mode without arrow keys
imap <C-B> <C-O>h

" move forward word in insert mode without arrow keys
imap <C-Z><C-F> <C-O>w

" move backward word in insert mode without arrow keys
imap <C-Z><C-B> <C-O>b

" copy current file basename to clipboard
nmap ,cpf :let @+=expand("%:t")<CR>

nmap ,cpb :let @+=expand("%:t") . ":" . line(".")<CR>

" copy full current file name to clipboard
nmap ,cpF :let @+=@%<CR>

" No inner stars on C-style-comments
autocmd BufRead,BufNewFile *.{h,hpp,c,cpp,cc} se comments=://,b:#,:%,:XCOMM,n:>,fb:- 

" Insert C-style comment
nmap ,cc i/*  */<Esc>2hi

" Automatic matched parentheses and brackets
"au BufRead,BufNewFile *.{h,hpp,c,cpp,cc,py,tcl,sc,pl,m,mm} inoremap <buffer> ( ()<Esc>i
"    \| inoremap <buffer> [ []<Esc>i
"    \| inoremap <buffer> { {}<Esc>i
"    \| inoremap <buffer> ' ''<Esc>i
"    \| inoremap <buffer> " ""<Esc>i

" stay at cursor position when switching buffers
se nosol

" wipe last opened buffer (useful if you make a mistake choosing what file to
" edit)
nmap ,BW :bw #<CR>

"Move one over after pasting
nnoremap P Pl

"Read in screen-exchange file
imap <C-R><C-S> <Esc>:.read /tmp/screen-exchange<CR>i
nmap <C-R><C-S> :.read /tmp/screen-exchange<CR>

"Fast typedef struct struct_t struct_t, just do struct_t<Esc>,tds
nmap ,tds yiw0itypedef struct <Esc>pa <Esc>$a;<Esc>
"Fast struct struct_t {};, just do struct_t<Esc>,tdd
nmap ,tdd yiw0istruct <Esc>$a {};<Esc>O

"Line numbers in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

"Add an empty line above or below without moving the cursor in Normal mode
nnoremap ,o m`o<Esc>``
nnoremap ,O m`O<Esc>``

"Conditional assignment bash, call on something like VAR=defaultval
autocmd BufRead,BufNewFile *.{sh,bash} nmap ,cs 0"byt=i[ -z $"bpa ] && 

"Swap / Pan windows, that is, move to previous window and expand vertically or
"horizontally
nmap  ,pw <C-W><C-P><C-W>\|
nmap  ,sw <C-W><C-P><C-W><C-_>

"Do a search to the first match and then turn off highlighting, gawd.
cmap <C-n> :<C-u>noh

"Exit insert mode but don't move cursor back OMFG
imap <C-_> <Esc>l
