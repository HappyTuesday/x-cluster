set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set number

autocmd FileType python set omnifunc=pythoncomplete#Complete 
autocmd FileType javascrīpt set omnifunc=javascriptcomplete#CompleteJS 
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
autocmd FileType css set omnifunc=csscomplete#CompleteCSS 
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags 
autocmd FileType php set omnifunc=phpcomplete#CompletePHP 
set t_Co=256
syntax enable
"set background=dark
"colorscheme solarized
"colorscheme candy
colorscheme distinguished
set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
