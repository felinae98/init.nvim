" Begin plugins
call plug#begin(stdpath('data') . '/plugged')

" file explorer system for vim
Plug 'preservim/nerdtree'
Plug 'altercation/vim-colors-solarized'
" sudo save
Plug 'lambdalisue/suda.vim'
" git plugin
Plug 'tpope/vim-fugitive'
" light line
Plug 'itchyny/lightline.vim'
" find file
Plug 'ctrlpvim/ctrlp.vim'
" grep things
Plug 'mileszs/ack.vim'
" quick comment
Plug 'tpope/vim-commentary'
" markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Chinese IM
Plug 'brglng/vim-im-select'

call plug#end()

" color
syntax enable
set background=dark
" let g:solarized_termcolors=256
colorscheme solarized

" general setting
set nocompatible
set encoding=utf8
set fileformats=unix,dos,mac
filetype plugin indent on
set autoread
set scrolloff=7
set wildmenu
set ruler
set hidden
set backspace=eol,start,indent
set whichwrap+=<,>,h,l " 比较复杂，见http://edyfox.codecarver.org/html/_vimrc_for_beginners.html
set lazyredraw " 执行宏时不进行重画
set magic " 搜索时指定的参数
set showmatch " 显示配对括号
set matchtime=5 " 显示配对括号的时间（单位为1/10秒）
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store " 忽略的文件
set relativenumber " 显示行号
set number
let mapleader="," " 将leader映射为逗号

" 关掉各种响铃和报错
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" 搜索相关
set ignorecase " 不区分大小写
set smartcase " 如果输入的pattern含大写，那么就区分大小写了
set hlsearch " 高亮搜索结果
set incsearch " 输入多少pattern实时显示搜索结果


" 取消备份文件（这个看自己）
set nobackup
set nowritebackup
set noswapfile

" 文本，tab，缩进
set expandtab " 将tab自动转换为空格
set smarttab " tab的长度与shiftwidth一致（之前与tabstop和softtablstop一致）
set shiftwidth=4 " 缩进长度大小
set tabstop=4 " 一个tab的大小
set linebreak " 太长换行
set autoindent " 在另起一行时继承上一行的indent
set smartindent " 写C-like程序的时候智能增加/减少缩进（其他语言的程序也可以）
set wrap " 超出编辑器宽度换行（与linebreak区别在于它可以中间截断一个词）


" Tricks
map <silent> <leader><cr> :noh<cr> " <leader>回车取消高亮

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" 搜索选定内容
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" 更方便的切换窗口
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" 在关闭文件之后也可以undo
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" plugin config
" suda
let g:suda_smart_edit=1
command! W w suda://%

" nerd tree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

" lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }
" ctrlp
let g:ctrlp_working_path_mode = 0

" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'
map <leader>j :CtrlP<cr>

" Quickly find and open a buffer
map <leader>b :CtrlPBuffer<cr>

" Quickly find and open a recently opened file
map <leader>f :CtrlPMRU<CR>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
" ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
map <leader>g :Ack 
" markdown preview
let g:mkdp_browser = 'firefox'
