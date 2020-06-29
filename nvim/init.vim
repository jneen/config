"
" sections:
" * plugins (configure / load)
" * settings
" * key bindings
" * local configuration
" * no good dirty awful hacks

" ==================== plugins ===================

set shell=$SHELL\ -il
" using the "Ack" plugin but actually using the "ag"
" program, to find patterns in a project
" :Ack some.*pattern
" see also the <Leader>s keyboard shortcuts
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

let g:ack_autoclose = 1
" option for the Suda plugin, allowing you to open files
" in "sudo mode", which prompts you for a password before
" saving
let g:suda_startup = 1

" for the CtrlP plugin, which is a fuzzy file finder
let g:ctrlp_working_path_mode = '0'

augroup FiletypeBehavior
  au BufRead,BufNewFile gitconfig set filetype=gitconfig
augroup END

" load plugins.
" turn syntax highlighting off while we load plugins,
" otherwise some bugs can happen
filetype off
source ~/.config/nvim/plug.vim
filetype plugin indent on
syntax on

" =================== settings ========================
set encoding=utf-8

set fileencodings=utf8,iso-2022-jp,euc-jp,cp932,latin1

" very basic status line (bottom of the screen)
" basically the same as the default but shows the file encoding
set statusline=%f%<%h%m%r%w\ [%{&fileencoding}]%=%l,%c%V\ %P

set modeline
set undofile

" 3 lines of space between cursor and edge,
set scrolloff=3

" 5 columns of space between cursor and edge
" disabled because we have line wrapping?
" set sidescrolloff=5

set undodir=~/.cache/vim/undo//
set directory=~/.cache/vim/swap//
set backupdir=~/.cache/vim/backup//

" shows special characters explicity (except for normal spaces)
set list listchars=tab:»\ ,trail:·,precedes:↪,extends:↩,nbsp:˾

" the t_Co setting is an older setting for "number of colours"
" even though we're fullcolor we set it to 256 so that plugins
" don't assume we're in low-color mode.
set t_Co=256

if has('termguicolors')
  set termguicolors
endif

" use soft 2-space indents
set autoindent expandtab shiftwidth=2 tabstop=2 softtabstop=2

" focus the opposite window when splitting
set splitright
set splitbelow

" allows the cursor to move freely even where there is no text,
" and preserves the current cursor position in some movements
set virtualedit=all
set nostartofline

" mouse integration
set mouse=a

" set wildmenu
" set wildmode=longest,full " this doesn't seem to work :(

" ignore these files in tab-completion (the CtrlP plugin will also
" ignore these)
set wildignore+=.git,.hg,tmp,node_modules
set wildignore+=*.o,*.so
set wildignore+=*.rbc
set wildignore+=*.pyc
set wildignore+=.*.sw[a-z]

" when opening diff files, ignore whitespace
set diffopt+=iwhite

set showcmd " partial commands
set ruler " line, column numbers in bottom right

" jneen's custom theme
colorscheme thankful_eyes

" ======================== key bindings ======================

" set the <Leader> key to spacebar
let mapleader=" "

" >> normal mode

" allocate a window for : commands
" (q: opens the command window, A puts us in insert mode at the end)
" (press ^C^C to exit without running a command)
nnoremap : q:A

" use ' to select the system clipboard before a command
nmap ' "+
vmap ' "+

" >> insert mode

" Disable arrow keys in insert mode
imap <silent> <Left> <nop>
imap <silent> <Right> <nop>
imap <silent> <Up> <nop>
imap <silent> <Down> <nop>

" >> visual mode

" select the last selection operated on
noremap <leader>V `[V`]

" perform an action on the last paste. accepts an <expr> - a movement command.
" try: dlp ("delete last paste")
"      vlp ("select last paste") (useful for reindenting)
"      clp ("change last paste")
vnoremap <silent> <expr> <Leader>lp ':<C-u>silent! normal! `[' . strpart(getregtype(), 0, 1) . '`]<cr>'
onoremap <silent> <expr> <Leader>lp ':<C-u>silent! normal! `[' . strpart(getregtype(), 0, 1) . '`]<cr>'

" >> git
" makes use of the Fugitive plugin
" i... don't actually use these much now that i have terminal mode,
" i just open a terminal with <Leader>sj and do git stuff in it instead
noremap <Leader>gs :Gstatus<cr>
noremap <Leader>gc :Gcommit -v<cr>
noremap <Leader>gd :Gdiff<cr>
noremap <Leader>ga :!git add %<cr>

" >> sudo (using the Suda plugin)
noremap <silent> <Leader>se :noh<cr>:e suda://%<cr>
noremap <silent> <Leader>sfs :noh<cr>:w suda://%<cr>

" >> files
" open cwd in the file explorer
noremap <silent> <Leader>f. :e .<cr>
" activate the fuzzy finder
noremap <silent> <Leader>ff :CtrlP<cr>
noremap <silent> <Leader>fm :CtrlPMRU<cr>
" if stuff isn't appearing in the fuzzy finder, clear the cache
" (also f5 in the finder interface)
noremap <silent> <Leader>fR :CtrlPClearCache<cr>
" make sure the file we're editing has a directory
noremap <silent> <Leader>fD :Mkdir!<cr>
" delete the current file and close the buffer
noremap <silent> <Leader>fr! :Remove!<cr>
" save
noremap <silent> <Leader>fs :<C-u>wall<cr><Esc>:<C-u>noh<cr>
" save only this file
noremap <silent> <Leader>fS :w<cr>:noh<cr>
" fe = file edit, for editing specific files that i'm always opening
noremap <silent> <Leader>fed :e ~/.config/nvim/init.vim<cr>
noremap <silent> <Leader>fep :e ~/.config/nvim/plug.vim<cr>
noremap <silent> <Leader>feR :so ~/.config/nvim/init.vim<cr>
noremap <silent> <Leader>feg :e ~/.gitconfig<cr>
noremap <silent> <Leader>fet :e ~/tmp/todo<cr>
noremap <silent> <Leader>fes :e ~/tmp/scratch<cr>
noremap <silent> <Leader>fev :e .envrc<cr>
noremap <silent> <Leader>fem :e Makefile<cr>
noremap <silent> <Leader>feD :e ./.init.vim<cr>
" refresh all files, in case they've changed on disk
noremap <silent> <Leader>fee :tabdo windo e<cr>
noremap <silent> <Leader>fe! :tabdo windo e!<cr>
" open the parent directory of the current file
noremap <silent> <Leader>fj :Explore<cr>
" go to the previous file we had open
noremap <silent> <Leader><Tab> <C-^>
" next and prev files for if you did vim f1 f2 f3 ...
noremap <silent> <Leader>fn :wn<cr>
noremap <silent> <Leader>fp :wN<cr>

" >> buffers
noremap <silent> <Leader>bb :CtrlPBuffer<cr>
noremap <silent> <Leader>bd :bdelete<cr>
noremap <silent> <Leader>b! :bdelete!<cr>

" >> quitting
noremap <silent> <Leader>qq :wq<cr>
noremap <silent> <Leader>qa :wqa<cr>
noremap <silent> <Leader>qt :tabclose<cr>
noremap <silent> <Leader>q! :q!<cr>

" >> window management. try all the things on the right and see what they do.
nmap <Tab> <Leader>w
noremap <silent> <Leader>wh <C-w>h
noremap <silent> <Leader>wl <C-w>l
noremap <silent> <Leader>wj <C-w>j
noremap <silent> <Leader>wk <C-w>k
noremap <silent> <Leader>wH <C-w>H
noremap <silent> <Leader>wL <C-w>L
noremap <silent> <Leader>wJ <C-w>J
noremap <silent> <Leader>wK <C-w>K

noremap <silent> <Leader>wv <C-w>v
noremap <silent> <Leader>ws <C-w>s
noremap <silent> <Leader>wc <C-w>c
noremap <silent> <Leader>wC :q!<cr>
noremap <silent> <Leader>wo <C-w>o

noremap <silent> <Leader>wx <C-w>x
noremap <silent> <Leader>ww <C-w>
noremap <silent> <Leader>w= <C-w>=

" searching (d = 'detect')
noremap <silent> <Leader>dk :noh<cr>
" noremap <silent> <Esc><Esc> <Esc><Esc>:noh<cr>
noremap          <Leader>ds /
" search the project for the thing under the cursor (<cword>)
noremap <silent> <Leader>dw :Ack -w <cword><cr>

" the few ruby-specific things - search for instances of `pry`
" (debugging, should not be committed) and also find the definition
" of the thing under the cursor
noremap <silent> <Leader>dp :Ack -w pry<cr>
noremap <silent> <Leader>dd :Ack '(^\s*(def\|module\|class)\s+(\w+\.)?<cword>\b\|\b<cword> =)'<cr>

" >> ctags
noremap <silent> <Leader>ct :tag<cr>

" >> terminals (s = 'shell')
" opens terminals in specified locations
noremap <silent> <Leader>ss :terminal<cr>
noremap <silent> <Leader>sj <C-w>s:terminal<cr>
noremap <silent> <Leader>sl <C-w>v:terminal<cr>
noremap <silent> <Leader>st :tabnew terminal<cr>
noremap <silent> <Leader>sm :make<cr>
noremap <silent> <Leader>sb <C-w>s:terminal bash %<cr>
noremap <silent> <Leader>s. :so %<cr>
noremap <silent> <Leader>se <C-w>s:terminal bash -c %<cr>
noremap <silent> <Leader>sx <C-w>s:terminal xmodmap %<cr>
noremap <silent> <Leader>so :!shell-fn open %<cr>

" use double-escape to go to terminal-normal mode
tnoremap <silent> <Esc><Esc> <C-\><C-n>

" i don't actually use these, but if press <C-space>
" in terminal mode it'll go to normal mode and then
" feed a <Leader> key, so you can go right into any
" of the other key sequences.
tmap <C-Space> <C-\><C-n><Space>
nmap <C-Space> <Space>

" esc-tab to move windows, in case you only hit esc once
tmap <Esc><Tab> <C-w>

" switch tabs, even when in a terminal

" >> tabs
" open a new tab with a terminal in it
noremap  <silent> <C-t> :tabnew +term<cr>
tnoremap <silent> <C-t> <C-\><C-n>:tabnew +term<cr>
" noremap <silent> <C-t> :tab term<cr>

" switch tabs
noremap  <silent> <C-j> :tabnext<cr>
tnoremap <silent> <C-j> <C-\><C-n>:tabnext<cr>

noremap  <silent> <C-k> :tabprev<cr>
tnoremap <silent> <C-k> <C-\><C-n>:tabprev<cr>

" rearrange tabs
" noremap <silent> <C-L> :+tabmove<cr>
noremap  <silent> <C-h> :-tabmove<cr>
tnoremap <silent> <C-h> <C-\><C-n>:-tabmove<cr>

" >> edits
" strip trailing whitespace
noremap <leader>ew :%s/\s\+$//<cr>

hi link coffeeSpaceError NONE

" let g:pyindent_continue = 'shiftwidth() / 2'
" unlet g:pyindent_nested_paren
" let g:pyindent_nested_paren = 'shiftwidth() / 2'

" ============================ local configuration ==================
" a prefix for project-local commands
let maplocalleader=","

" try to load the local configuration, if it exists
if filereadable(".init.vim")
  so .init.vim
endif

" keybindings to edit the local configs
" (notice these are `,fed` and `,feR`, not the spacebar
" ones like up above. and they edit stuff for the
" current directory, not globally)
noremap <LocalLeader>fed :e ./.init.vim<cr>
noremap <LocalLeader>feR :so ./.init.vim<cr>

" nvim specific
augroup TermBehavior
  autocmd BufEnter,TermOpen term://* startinsert | set bufhidden=delete
  autocmd TermClose * call feedkeys('<cr>')
augroup END

augroup NewFileBehavior
  autocmd BufNewFile * let b:is_new_file = 1
  autocmd BufWritePre * if exists('b:is_new_file') | Mkdir! | endif
augroup END


" ================== ugly no-good hacks =====================

" hack for mainline vim. i hate this, but it's the only way to get <M-*>
" bindings to work (using Alt). ymmv.
"
" basically in some terminals Alt is replaced by an Esc (^]) *prefix*, so
" we have to tell vim to interpret that as an Alt
" let c='a'
" while c <= 'z'
"   exec "set <A-".c.">=\e".c
"   exec "imap \e".c." <A-".c.">"
"   let c = nr2char(1+char2nr(c))
" endw
" set timeout ttimeoutlen=3
" end hack
