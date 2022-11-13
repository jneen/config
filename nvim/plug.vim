call plug#begin('~/.config/nvim/bundle')

Plug 'ap/vim-css-color'
" editorconfig for shared projects
Plug 'editorconfig/editorconfig-vim'

" thanks tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

Plug 'lambdalisue/suda.vim'
" Plug 'chrisbra/SudoEdit.vim'
Plug 'christoomey/vim-sort-motion'
Plug 'mileszs/ack.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'vim-airline/vim-airline'

" Plug 'scrooloose/syntastic'

" ~*~ ft-specific plugins ~*~

" polyglot
" Plug 'sheerun/vim-polyglot'

" js
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'kchmck/vim-coffee-script'

" rust
Plug 'rust-lang/rust.vim'

" Pug
Plug 'digitaltoad/vim-pug'

" ruby
" Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'

" clojure
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-leiningen'

" docker
" Plug 'honza/dockerfile.vim'

" markdown
Plug 'tpope/vim-markdown'

" godot
Plug 'habamax/vim-godot'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" glsl
Plug 'tikhomirov/vim-glsl'

" theme
Plug 'jneen/thankful_eyes.vim'

" Plug 'bfrg/vim-cpp-modern'

call plug#end()
