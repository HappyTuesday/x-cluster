set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set number
set ruler
set showmatch
set wildmenu
set showcmd
set autoread
set foldmethod=marker
set clipboard+=unnamed
set list
set listchars=tab:>-,trail:-
set autochdir
set hidden
set t_Co=256

"set background=dark
"colorscheme solarized
"colorscheme candy
colorscheme distinguished

filetype on
autocmd FileType python set omnifunc=pythoncomplete#Complete 
autocmd FileType javascrīpt set omnifunc=javascriptcomplete#CompleteJS 
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
autocmd FileType css set omnifunc=csscomplete#CompleteCSS 
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags 
autocmd FileType php set omnifunc=phpcomplete#CompletePHP 
syntax enable

"ctags

"taglist
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Show_One_File=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_SingleClick=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Process_File_Always=1

"auto compile and run
func! RunPython()
    exec "!python %"
endfunc

func! CompileCode()
    exec "w"
    if &filetype == "python"
        exec "call RunPython()"
    endif
endfunc

nmap <F5> :call CompileCode()<CR>

func! OpenTempWindow()
    if &filetype == "python"
        exec "vsp " . tempname() . ".py"
    endif
endfunc

nmap <F9> :call OpenTempWindow()<CR>
