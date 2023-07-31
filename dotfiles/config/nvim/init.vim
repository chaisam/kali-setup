syntax on
filetype plugin on
set nocompatible
set exrc
set guicursor=
set smartindent
set nu
set smartcase
set noswapfile
set nobackup
set incsearch
set undodir=~/.vim/undodir
set undofile
set backspace=indent,eol,start " more powerful backspacing
set colorcolumn=100
set relativenumber
set hlsearch
set hidden
set noerrorbells
" set nowrap
set scrolloff=8
set signcolumn=yes

" Ignore those files - usefull for ctrlp search
set wildignore+=*.a,*.o
set wildignore+=*.db,*.vmdk,*.iso,*.mp4
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.pdf,*.odt,*.docx
"indend with za zc zo zC zO zm
set foldmethod=indent
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'turbio/bracey.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter',
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'jpalardy/vim-slime'
Plug 'mileszs/ack.vim'
Plug 'vimwiki/vimwiki'
call plug#end()


colorscheme gruvbox
set background=dark

imap jj <ESC>
let mapleader = " " " map leader to Space

"mapping for moving from panes in nerdtree & ctrlp panes
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>
nnoremap <Leader>pt :NERDTreeToggle<Enter>
nnoremap <silent><Leader>pv :NERDTreeFind<CR>
"let g:ctrlp_map = '<c-p>'
"let g:ctrlp_cmd = 'CtrlP'

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>bi <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"https://stackoverflow.com/questions/18948491/running-python-code-in-vim
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

nmap <F6> :exec '!'.getline('.')<cr>
nmap <F5> wa<CR>:make! run \| copen<CR>

function! FindAll()
    call inputsave()
    let p = input('Enter pattern:')
    call inputrestore()
    execute 'vimgrep "'.p.'" % |copen'
endfunction
nnoremap <F8> :call FindAll()<cr>

nnoremap <backspace> :tabp<cr>
nnoremap <TAB> :tabn<cr>

"Ref https://www.youtube.com/watch?v=hSHATqh8svM
nnoremap J mzJ`z
nnoremap N Nzzzv
nnoremap J mzJ`z

"Undo Break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
"Need to add here the others

"map the vim leader key(Space key) to copy & paste to do that to clipboard
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nnoremap H 0
nnoremap L $
"
"neovide stuff
let g:neovide_cursor_trail_length=2
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_animation_length=0.11

set mouse=a
"let g:slime_target = "neovim"
let g:slime_target = "tmux"
