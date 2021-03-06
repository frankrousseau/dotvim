" Chargement de Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Activation de l'indentation automatique
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Redéfinition des tabulations
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Activation de la détection automatique du type de fichier
" Rechargement du file type
filetype off
filetype on
filetype plugin indent on

" Longueur maximale des lignes
set textwidth=79


" Activation de la coloration syntaxique
syntax on

" Lecture des raccourcis clavier généraux
execute 'source ' . $HOME . '/.vim/shortkeys.vim'

" Coloration YAML
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim

" Activation de la complétion pour les fichiers python
au FileType python set omnifunc=pythoncomplete#Complete
" Activation de la complétion pour les fichiers javascript
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" Activation de la complétion pour les fichiers html
au FileType html set omnifunc=htmlcomplete#CompleteTags
" Activation de la complétion pour les fichiers css
au FileType css set omnifunc=csscomplete#CompleteCSS

" Définition du type de complétion de SuperTab
let g:SuperTabDefaultCompletionType = "context"

" Activation de la visualisation de la documentation
set completeopt=menuone,longest,preview

" Activation de la complétion pour Django
function! SetAutoDjangoCompletion()
  let l:tmpPath   = split($PWD, '/')
  let l:djangoVar = tmpPath[len(tmpPath)-1].'.settings'
  let $DJANGO_SETTINGS_MODULE=djangoVar
  echo 'Activation de la complétion Django avec : '.djangoVar
  return 1
endfunction

" Activation de la complétion pour les librairies installées dans virtualenv
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Activation des snippets Django pour les fichiers python et html
autocmd FileType python set ft=python.django
autocmd FileType html set ft=htmldjango.html

" Activation de la barre de status de fugitive
set laststatus=2
set statusline=set statusline=[L=%04l]\ [C=%04v]\ [%p%%]\ %{fugitive#statusline()}

" Fonction d'affichage d'un message en inverse vidéo
function! s:DisplayStatus(msg)
  echohl Todo
  echo a:msg
  echohl None
endfunction

" Variable d'enregistrement de l'état de la gestion de la souris
let s:mouseActivation = 1
" Fonction permettant l'activation/désactivation de la gestion de la souris
function! ToggleMouseActivation()
  if (s:mouseActivation)
    let s:mouseActivation = 0
    set mouse=n
    set paste
    call s:DisplayStatus('Désactivation de la gestion de la souris (mode '.
                         'collage)')
  else
    let s:mouseActivation = 1
    set mouse=a
    set nopaste
    call s:DisplayStatus('Activation de la gestion de la souris (mode normal)')
  endif
endfunction

" Activation par défaut au démarrage de la gestion de la souris
set mouse=a
set nopaste

" Fonction de 'nettoyage' d'un fichier :
"   - remplacement des tabulations par des espaces
"   - suppression des caractères ^M en fin de ligne
function! CleanCode()
  %retab
  %s/^M//g
  call s:DisplayStatus('Code nettoyé')
endfunction

" Affichage des numéros de ligne
" set number
" highlight LineNr ctermbg=blue ctermfg=gray

" Surligne la colonne du dernier caractère autorisé par textwidth
set cc=+1

" Ouverture des fichiers avec le curseur à la position de la dernière édition
function! s:CursorOldPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
    exe "normal g`\""
  endif
endfunction
autocmd BufReadPost * silent! call s:CursorOldPosition()

" Ctrl-s pour sauvegarder
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

" Improve search
set smartcase
set incsearch

" Enable coffee script folding
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

" Bubble single lines
nmap <Up> ddkP
nmap <Down> ddp
imap <Up> <Esc>ddkPi
imap <Down> <Esc>ddpi
nmap <Left> <<
nmap <Right> >>
imap <Left> <Esc><<i
imap <Right> <Esc>>>i
vmap <Left> <<
vmap <Right> >>

" Bubble multiple lines
vmap <Up> xkP`[V`]
vmap <Down> xp`[V`]

" Make , as leader key
let mapleader = ","
nnoremap <silent> <F7> :NERDTreeToggle<CR>
nnoremap <silent> <F6> :Gcommit<CR>

nnoremap u i
nnoremap z u

" search text in different files
nnoremap gr :grep <cword> *<CR>

" Autosave
map <Esc><Esc> :w<CR>

nmap <F3> :update<CR>
vmap <F3> <Esc><F3>gv
imap <F3> <c-o><F3>


set autowrite
au FocusLost * :wa

au BufRead,BufNewFile * let b:start_time=localtime()
au CursorHold * call UpdateFile()
" only write if needed and update the start time after the save
function! UpdateFile()
  if ((localtime() - b:start_time) >= 60)
    update
    let b:start_time=localtime()
  else
    echo "Only " . (localtime() - b:start_time) . " seconds have elapsed so far."
  endif
endfunction
au BufWritePre * let b:start_time=localtime()

" Colors
" colorscheme ir_black
colorscheme molokai

"relive trailing whitespaces
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.coffee :%s/\s\+$//e
autocmd BufWritePre *.js :%s/\s\+$//e

" Exception pour les fichier js
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

" Experiments
"
"
set number " numero de ligne
set cursorline " highlight de la ligne courante
set wildmenu " menu d'autocompletion pour les fichiers
set lazyredraw " ne recalcule pas toujours tout
set showmatch " match les parentheses
set incsearch " recherche incrémentale
set hlsearch " highilight search matches
nnoremap <leader><space> :nohlsearch<CR> " remove search highlight

" folding
set foldenable 
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za
set foldmethod=indent

" move vertically by visual line
nnoremap j gj
nnoremap k gk

nnoremap B ^
nnoremap E $
nnoremap gV `[v`]
inoremap jk <esc>

" Utilitaires de recheche CtrlP + ag
nnoremap <leader>a :Ag 
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
