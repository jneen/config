call plug#begin('~/.vim/bundle')

" thanks tpope

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

Plug 'lambdalisue/suda.vim'
" Plug 'chrisbra/SudoEdit.vim'

Plug 'mileszs/ack.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'vim-airline/vim-airline'

" Plug 'scrooloose/syntastic'

" ~*~ ft-specific plugins ~*~

" js
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'

" Pug
Plug 'digitaltoad/vim-pug'

" ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'

" clojure
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-leiningen'

" docker
" Plug 'honza/dockerfile.vim'

" markdown
Plug 'tpope/vim-markdown'

" supercollider
" Plug 'sbl/scvim'

" tabs!
" Plug 'gcmt/taboo.vim'

" pdfs
" Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" llvm
" " [jneen] this plugin breaks entering comments in non-llvm buffers :<
" Plug 'Superbil/llvm.vim'

" tulip!
" Plug 'tulip-lang/tulip', { 'rtp': 'vim/' }
" Plug '~/src/tulip/vim'

" theme
Plug 'jneen/thankful_eyes.vim'

call plug#end()
