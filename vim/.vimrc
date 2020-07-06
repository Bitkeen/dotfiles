" Main {{{

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if &t_Co > 2 || has('gui_running')
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

if exists('$TMUX')
  " Enable mouse when in tmux.
  set ttymouse=xterm2

  " Bracketed paste works by default in Vim 8, but not when in tmux.
  let &t_BE = "\<Esc>[?2004h"
  let &t_BD = "\<Esc>[?2004l"
  let &t_PS = "\<Esc>[200~"
  let &t_PE = "\<Esc>[201~"

  " Wrap escape sequences for tmux.
  let &t_SI = "\ePtmux;\e\e[5 q\e\\"
  let &t_EI = "\ePtmux;\e\e[2 q\e\\"
  let &t_SR = "\ePtmux;\e\e[3 q\e\\"
else
  " Blinking bar cursor in insert mode.
  let &t_SI = "\e[5 q"
  " Steady block cursor in normal mode.
  let &t_EI = "\e[2 q"
  " Blinking underscore cursor in replace mode.
  let &t_SR = "\e[3 q"
endif

" Maintain indent of current line.
set autoindent

" Only do this part when compiled with support for autocommands.
if has('autocmd')
  augroup main
    autocmd!

    " Don't automatically insert comment leader for new lines.
    autocmd FileType * setlocal formatoptions-=o

    " Make underscore a word separator.
    autocmd FileType text setlocal iskeyword-=_

    " Colorcolumns.
    autocmd FileType * setlocal colorcolumn=0
    autocmd FileType c setlocal colorcolumn=81
    autocmd FileType lua setlocal colorcolumn=81
    autocmd FileType python setlocal colorcolumn=81
    autocmd FileType vim setlocal colorcolumn=81
    autocmd FileType sh setlocal colorcolumn=81

    " Tab widths.
    autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType c,go,ledger,make,snippets,xquery setlocal noexpandtab
    autocmd FileType c setlocal shiftwidth=8 tabstop=8
    autocmd FileType json,terraform,vim,yaml* setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " Open help windows in a vertical split by default.
    autocmd FileType help wincmd L
    " Show line numbers in help windows.
    autocmd FileType help,man setlocal number
    autocmd FileType help,man setlocal relativenumber
    " Only show signcolumn when there is a sign to display.
    autocmd FileType help,man setlocal signcolumn=auto

    " Highlight the current line, but only in focused window.
    autocmd BufEnter,WinEnter,FocusGained * setlocal cursorline
    autocmd WinLeave,FocusLost * setlocal nocursorline

    " See https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly.
    autocmd FileType vue syntax sync fromstart

    " Reload binds when sxhkdrc is updated.
    autocmd BufWritePost *sxhkdrc silent !pkill -USR1 sxhkd
    " Reload Xresources on update.
    autocmd BufWritePost *Xresources, silent !xrdb %
    " Reload i3 config on update.
    autocmd BufWritePost */i3/config, silent !i3-msg restart

    autocmd BufWinEnter *.rules setlocal filetype=udevrules
  augroup END

  augroup folding
    autocmd!
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType yaml setlocal foldmethod=indent
    autocmd FileType html,xml setlocal foldmethod=indent
    autocmd BufWinEnter .vimrc,.bash*,.tmux.conf,*/i3/config setlocal foldmethod=marker
    autocmd BufWinEnter .vimrc,.bash*,.tmux.conf,*/i3/config setlocal foldlevel=0
  augroup END
endif

" Automatically refresh current file on if it was changed
" outside of Vim.
set autoread
if has('autocmd')
  augroup refresh
    autocmd!
    " 'checktime' causes errors in command line windows
    " (q/, q:), 'silent!' ignores these errors
    autocmd CursorHold,CursorHoldI * :silent! checktime
    autocmd FocusGained,BufEnter * :silent! checktime
  augroup END
endif

if has('packages')
  " Default plugins in vim distribution.
  packadd cfilter " Filter a quickfix or location list
  packadd matchit " Extended matching with '%'

  if has('python3')
    packadd MatchTagAlways
    packadd completor.vim
    packadd ultisnips
  endif

  packadd! ale " Asynchronous Lint Engine
  packadd! base16-vim " Themes
  packadd! CamelCaseMotion " CamelCase and snake_case movement mappings
  packadd! committia.vim
  packadd! conflict-marker.vim
  packadd! fugitive-gitlab.vim
  packadd! fzf.vim
  packadd! git-blame.vim " See blame information in the bottom line
  packadd! gundo.vim " Graph undo tree
  packadd! gv.vim " Git commit browser. Requires fugitive
  packadd! indentLine " Display vertical lines at each indentation level
  packadd! jedi-vim " Python autocompletion
  packadd! lightline-ale
  packadd! lightline.vim " A light and configurable statusline/tabline
  packadd! linediff.vim " Diff two blocks of text
  packadd! pydoc.vim
  packadd! python-syntax " Better python syntax highlighting
  packadd! QFEnter " Open a Quickfix item in a window you choose
  packadd! quick-scope
  packadd! quickpeek.vim " A preview popup on quickfix entries
  packadd! requirements.txt.vim
  packadd! splitjoin.vim " Switch between single-line and multiline forms of code
  packadd! tabular
  packadd! tagbar " A class outline viewer using ctags
  packadd! targets.vim " Additional text objects
  packadd! textobj-word-column.vim
  packadd! tmuxline.vim " Tmux status line generator
  packadd! traces.vim " For :substitute previews
  packadd! undoquit.vim
  packadd! vim-abolish
  packadd! vim-auto-save
  packadd! vim-characterize
  packadd! vim-closer
  packadd! vim-commentary " Easy commenting
  packadd! vim-easydir
  packadd! vim-endwise
  packadd! vim-eunuch
  packadd! vim-exchange
  packadd! vim-expand-region
  packadd! vim-fugitive " Git wrapper
  packadd! vim-gitgutter " Show a git diff in the sign column
  packadd! vim-gnupg
  packadd! vim-grepper " Use search tools in a vim split
  packadd! vim-gtfo
  packadd! vim-highlightedyank
  packadd! vim-indent-object
  packadd! vim-instant-markdown " Instant markdown previews
  packadd! Vim-Jinja2-Syntax
  packadd! vim-ledger
  packadd! vim-merginal " Interface for dealing with Git branches
  packadd! vim-obsession
  packadd! vim-pug
  packadd! vim-python-pep8-indent
  packadd! vim-qfreplace " Change lines from quickfix
  packadd! vim-qlist
  packadd! vim-ragtag
  packadd! vim-repeat
  packadd! vim-rhubarb
  packadd! vim-rsi " Readline style insertion
  packadd! vim-scriptease
  packadd! vim-searchindex
  packadd! vim-signature " A plugin to toggle, display and navigate marks
  packadd! vim-signjump " Jump to signs just like other object motions
  packadd! vim-slime
  packadd! vim-speeddating
  packadd! vim-superman
  packadd! vim-surround
  packadd! vim-swap
  packadd! vim-sxhkdrc
  packadd! vim-syntax-extra
  packadd! vim-textobj-comment " Text objects for comments
  packadd! vim-textobj-conflict
  packadd! vim-textobj-entire
  packadd! vim-textobj-user
  packadd! vim-textobj-xmlattr
  packadd! vim-tmux-focus-events
  packadd! vim-tmux-navigator
  packadd! vim-vinegar
  packadd! vim-visual-star-search
  packadd! vim-vue
  packadd! vim-xkbswitch " Automatically switch keyboard layout based on mode
  packadd! vimwiki " Personal wiki for Vim
  packadd! vZoom.vim " Quickly maximize & unmaximize the current window
  packadd! winresizer " Easy window resizing, similar to resize mode in i3wm
else
  " Enable Pathogen package manager.
  execute pathogen#infect('pack/bundle/opt/{}')
endif

filetype plugin indent on

" Enable syntax highlighting.
syntax enable

" If you set the 'incsearch' option, Vim will show the first match
" for the pattern, while you are still typing it. This quickly shows a
" typo in the pattern.
set incsearch

" Make search case-insensitive.
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper
" case characters.
set smartcase

" Don't insert two spaces after '.', '?' and '!' for join command.
set nojoinspaces

" Enable line numbers.
set number
" Enable relative line numbers.
set relativenumber

" Keep a backup file (restore to previous version).
set backup
if has('persistent_undo')
  " Keep an undo file (undo changes after closing).
  set undofile
endif

" Set directory to save swap files in.
set directory=~/.vim/tmp/swap//

" Save backup files in ~/.vim/backups.
set backupdir=~/.vim/tmp/backup//

" Save undo files in ~/.vim/backups/undo.
set undodir=~/.vim/tmp/undo//

" Save viminfo in ~/.vim/.viminfo.
set viminfo+=n~/.vim/tmp/viminfo

" A view is a vim script that resotres the contents of the current
" window.
set viewdir=~/.vim/tmp/view//

" Search down into subfolders.
" Provides tab-completion for all file-related tasks.
set path+=**

" Default is 2000.
set redrawtime=10000

" Remove comment chars when joining comments.
set formatoptions+=j

" Show trailing whitespace as middle dots (when 'list' is set).
" Tab is U+21B9. Slash escapes the space.
" Nbsp is U+25AF.
set listchars=trail:·,tab:↹\ ,nbsp:▯

" Always show status line.
set laststatus=2

" Always start editing with all folds open.
set foldlevelstart=99

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default.
set splitbelow
set splitright

set clipboard=unnamedplus

" Don't show current mode on the last line, e.g. `-- INSERT --`.
set noshowmode

" Don't move the cursor to the first non-blank of the line
" on Ctrl-D, Ctrl-U, gg, G, etc.
set nostartofline

" Allow cursor to move where there is no text in visual block mode.
set virtualedit=block

" Put a string at the start of lines that have been wrapped.
set showbreak=›

" Indent wrapped lines at the same amount of space as the
" beginning of that line.
set breakindent
if exists('&breakindentopt')
  set breakindentopt=shift:1
endif

" If this many milliseconds nothing is typed the swap file
" will be written. Also used for the CursorHold event.
set updatetime=100

" Commandline history size. Default is 50.
if &history < 1000
  set history=1000
endif

" Don't show intro message.
set shortmess+=I
" Don't show the "ATTENTION" message when an existing swap file
" is found.
set shortmess+=A

" Command-line completion mode.
" Complete the next full m
" atch, show wildmenu.
set wildmode=full

" Ignore case when completing file names and directories.
set wildignorecase

" Vim before 8.1.1365 is vulnerable to arbitrary code execution via modelines
" by opening a specially crafted text file.
if !has('patch-8.1-1366')
  set nomodeline
else
  " Disallow options that are an epxression to be set in the modeline.
  " Default is off, but it is still included here.
  set nomodelineexpr
endif

" Netrw
let g:netrw_banner=0
" Tree view.
let g:netrw_liststyle=3
" Directory where netrw saves .netrwhist and .netrwbook.
let g:netrw_home = '~/.vim/tmp'

" Enable basic fzf plugin.
set runtimepath+=/usr/bin/fzf

" Highlight the text line without line number.
set cursorlineopt=line

function! CloseQuickfixWindows()
  let l:current_tab = tabpagenr()
  tabdo windo lclose | cclose
  " Return to the most recent tab.
  execute "tabnext" l:current_tab
endfunction

function! s:wrapped_obsession()
  " Source Session.vim if it exists, start a new session otherwise.
  if getfsize('Session.vim') > 0
    source Session.vim
  else
    Obsession
  endif
endfunction

command! WrappedObsession execute s:wrapped_obsession()

let g:formatter_mapping = {
\ 'html': '!tidy -q -i --show-errors 0',
\ 'json': '!python -m json.tool',
\ 'python': '!autopep8',
\ 'sql': '!pg_format',
\ 'xml': '!tidy -q -i --show-errors 0 -xml',
\}

function! FormatFile(filetype, range_prefix)
  " Get and execute a formatter from g:formatter_mapping based on
  " filetype argument for the specified range.
  let l:formatter = get(g:formatter_mapping, a:filetype)
  if a:filetype ==# ''
    echo 'Filetype not specified'
  elseif l:formatter !=# '0'
    execute a:range_prefix . get(g:formatter_mapping, a:filetype)
  else
    echo 'No formatter for ' . a:filetype
  endif
endfunction

" }}}

" Plugin configuration {{{

augroup plugins
  autocmd!
augroup END

" indentLine
let g:indentLine_fileType = ['python', 'lua', 'vim', 'xquery']
" U+2502: BOX DRAWINGS LIGHT VERTICAL.
let g:indentLine_char = '│'

" vim-instant-markdown
let g:instant_markdown_autostart = 0

" vimwiki {{{
let g:vimwiki_list = [
\  {'path': '~/sync/wikis/mainwiki', 'syntax': 'markdown', 'ext': '.md'},
\  {'path': '~/sync/wikis/phonewiki', 'syntax': 'markdown', 'ext': '.md'},
\  {'path': '~/sync/wikis/workwiki', 'syntax': 'markdown', 'ext': '.md'},
\]
" vimwiki markdown support.
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_hl_headers = 1
" }}}

" vim-xkbswitch
let g:XkbSwitchEnabled = 1

" vim-commentary {{{
autocmd plugins FileType abp setlocal commentstring=!%s
autocmd plugins FileType requirements setlocal commentstring=#\ %s
autocmd plugins FileType xquery setlocal commentstring=(:\ %s\ :)
autocmd plugins FileType xdefaults setlocal commentstring=!%s
" }}}

" vim-gitgutter {{{
" Always show the sign column.
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
" }}}

" jedi-vim
" Disable jedi completions as they are now handled by completor.
let g:jedi#completions_enabled = 0

" base16-vim {{{
" Colorscheme local customization.
function! s:base16_tomorrow_night_custom() abort
  call Base16hi('PMenuSel', g:base16_gui05, g:base16_gui01, g:base16_cterm05, g:base16_cterm01, 'reverse', '')
  call Base16hi('Comment', g:base16_gui03, '', g:base16_cterm03, '', 'italic', '')
endfunction

augroup on_change_colorscheme
  autocmd!
  autocmd ColorScheme base16-tomorrow-night call s:base16_tomorrow_night_custom()
augroup END

" .vimrc_background sets colorscheme.
if filereadable(expand('~/.vimrc_background'))
  " Access colors present in 256 colorspace.
  let base16colorspace=256
  source ~/.vimrc_background
endif
" }}}

" Gundo
let g:gundo_prefer_python3 = 1

" vim-slime
let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
augroup slime
  autocmd!
  " Disable linting.
  autocmd BufWinEnter */.vim/slime/repl.py :ALEDisable
  autocmd BufWinEnter */.vim/slime/repl.lua :ALEDisable
  " Enable auto-save.
  autocmd BufWinEnter */.vim/slime/repl.py :let b:auto_save = 1
  autocmd BufWinEnter */.vim/slime/repl.lua :let b:auto_save = 1
  " Don't display the auto-save notification.
  autocmd BufWinEnter */.vim/slime/repl.py :let g:auto_save_silent = 1
  autocmd BufWinEnter */.vim/slime/repl.lua :let g:auto_save_silent = 1
augroup END

" UltiSnips
let g:UltiSnipsEditSplit = 'context'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" pydoc.vim
let g:pydoc_open_cmd = 'vsplit'
let g:pydoc_highlight = 0

autocmd plugins FileType todo :let b:auto_save = 1

" quickpeek.vim
let g:quickpeek_popup_options = {'title': 'Preview'}
let g:quickpeek_window_settings = ['cursorline', 'number', 'relativenumber']

" }}}

" Mappings {{{

let mapleader=' '
" Backslash needs to be escaped.
let maplocalleader="\\"

" Toggle spell-check.
map <F6> :setlocal spell! spelllang=en_us<CR>

" Use j and k if a count is specified, gj, gk if no count is specified.
" For counts larger or equal to five, set a mark that can be used in
" the jump list.
nnoremap <expr> j (v:count > 4 ? "m'" . v:count : '') . (v:count >= 1 ? 'j' : 'gj')
nnoremap <expr> k (v:count > 4 ? "m'" . v:count : '') . (v:count >= 1 ? 'k' : 'gk')
" No marks in visual mode.
vnoremap <expr> j v:count > 1 ? 'j' : 'gj'
vnoremap <expr> k v:count > 1 ? 'k' : 'gk'

nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

" By default Y is synonym for yy. Remap it to yank from
" the cursor to the end of the line, similar to C or D.
nnoremap Y y$

nnoremap yp :let @+ = expand('%:t') \| echo 'Yanked "' . @+ . '"'<CR>
nnoremap yP :let @+ = expand('%:p') \| echo 'Yanked "' . @+ . '"'<CR>

" Write with sudo.
" See https://stackoverflow.com/a/7078429.
nnoremap <Leader>U :write !sudo tee > /dev/null %<CR>

" Quicker window movement.
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" Open (in) a new tab.
nnoremap <Leader>gn :tabnew<Space>
" Switch tabs.
nnoremap <silent> <Leader>gj :tabfirst<CR>
nnoremap <silent> <Leader>gk :tablast<CR>
" Move tabs.
nnoremap <silent> <Leader>gH :-tabmove<CR>
nnoremap <silent> <Leader>gJ :0tabmove<CR>
nnoremap <silent> <Leader>gK :$tabmove<CR>
nnoremap <silent> <Leader>gL :+tabmove<CR>

" The first part clears the last used search. It will not set the pattern to
" an empty string, because that would match everywhere. The pattern is really
" cleared, like when starting Vim.
" The second part disables highlighting, redraws the screen (default
" behavior for C-l) and moves one character to the left with 'h' (to keep
" the cursor in place).
nnoremap <silent> <Leader>l :let @/ = ""<CR> :nohlsearch<CR><c-l>h

" Reload .vimrc.
nnoremap <LocalLeader>r :source $MYVIMRC<CR>

" Save.
nnoremap <Leader>u :update<CR>
" Save and quit.
nnoremap <Leader>x :x<CR>
" Quit without saving.
nnoremap <Leader>q :q<CR>
vnoremap <Leader>q <Esc>:q<CR>

" Edit file, starting in same directory as current file.
nnoremap <Leader>ew :edit <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>eb :split <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>ev :vsplit <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>et :tabedit <C-R>=expand('%:p:h') . '/'<CR>

" Visually select last changed or yanked text.
nnoremap <Leader>v `[v`]

" Open empty splits.
nnoremap <Leader>- :new<CR>
nnoremap <Leader>\ :vnew<CR>
" Without switching to normal mode, new split will be zoomed.
vnoremap <Leader>- <Esc>:new<CR>
vnoremap <Leader>\ <Esc>:vnew<CR>
" Similar to 'split-window -f' in tmux, split the whole page.
" -1 is to accouunt for the command line.
nnoremap <silent><Leader>_ :new<CR><C-w>J:exec 'resize ' . (&lines/2-1)<CR>
" Need to escape '|'.
nnoremap <silent><Leader>\| :vnew<CR><C-w>L:exec 'vertical resize ' . (&columns/2)<CR>
" Open a new empty tab.
nnoremap <Leader>/ :tabnew<CR>

" Open current file in a vertical split.
nnoremap <Leader><C-v> :vsplit %<CR>
nnoremap <Leader><C-b> :split %<CR>

" Substitute.
nnoremap <Leader>s :%s/
vnoremap <Leader>s :s/

" Remove trailing whitespace.
nnoremap <LocalLeader>tw :%s/\s\+$//e<CR>
vnoremap <LocalLeader>tw :s/\s\+$//e<CR>

" Remove empty lines through entire file.
nnoremap <Leader>el :g/^$/d<CR>

" Make all windows the same height and width.
nnoremap <Leader>= <C-W>=

" Open an empty tab and close all the other tabs.
" Don't close the buffers.
nnoremap <silent> <LocalLeader>qq :tabnew<CR>:tabonly!<CR>
vnoremap <silent> <LocalLeader>qq <Esc>:tabnew<CR>:tabonly!<CR>
" Close all buffers.
nnoremap <silent> <LocalLeader>qa :qall!<CR>
vnoremap <silent> <LocalLeader>qa :qall!<CR>
" Leave only current tab and current window.
nnoremap <silent> <LocalLeader>qo :tabonly<CR>:only<CR>
vnoremap <silent> <LocalLeader>qo <Esc>:tabonly<CR>:only<CR>
" Close current tab.
nnoremap <silent> <LocalLeader>qt :tabclose<CR>
vnoremap <silent> <LocalLeader>qt <Esc>:tabclose<CR>
" Close quickfix windows.
nnoremap <silent> <LocalLeader>qf :call CloseQuickfixWindows()<CR>
vnoremap <silent> <LocalLeader>qf <Esc>:call CloseQuickfixWindows()<CR>

" Repeat the previous @, can be used with a count.
nnoremap <Leader><Leader> @@

nnoremap [h :help<Space>
nnoremap ]h :tab help<Space>

" Compare buffers in current tab.
nnoremap [w :windo diffthis<CR>
" Turn diff mode off.
nnoremap ]w :windo diffoff<CR>

" Go to tab by number
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
" 9 instead of 0, similar to the default mapping in Firefox.
noremap <silent> <Leader>9 :tablast<CR>

" Put the text after current line.
nnoremap <Leader>p :put<CR>
" Put the text before current line.
nnoremap <Leader>P :put!<CR>

nnoremap <Leader>o :copen<CR>

" Default mappings for [f and ]f are the same as "gf" and are deprecated.
" Show current filetype.
nnoremap [f :echo &filetype<CR>
" Change filetype.
nnoremap ]f :set filetype=
vnoremap ]f <Esc>:set filetype=

" Toggle invisible characters.
nnoremap <LocalLeader>l :set list!<CR>

" Insert a space before/after the current position.
nnoremap [<Space> i<Space><Esc>
nnoremap ]<Space> a<Space><Esc>
" Insert a blank line below/above the current line.
nnoremap [n O<Esc>j
nnoremap ]n o<Esc>k

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

if has('autocmd')
  " Compiling TeX.
  augroup texmaps
    autocmd!
    " Map F3 to compile LaTeX. The last <Enter> skips the log.
    autocmd FileType tex noremap <F3> :w<Enter>:!pdflatex<Space>%<Enter><Enter>
    " Map F4 to compile XeTeX.
    autocmd FileType tex noremap <F4> :w<Enter>:!xelatex<Space>%<Enter><Enter>
  augroup END
  " Quickfix window mappings.
  augroup qfmaps
    autocmd!
    " Go to older error list.
    autocmd FileType qf nnoremap <Leader>H :colder<CR>
    " Go to newer error list.
    autocmd FileType qf nnoremap <Leader>L :cnewer<CR>
  augroup END
endif

" Replace search term under the cursor, dot repeats the change.
nnoremap c* *Ncgn
nnoremap c# #NcgN

" Paste from the command register.
" `noremap!` maps both for the insert and the command-line mode.
noremap! <C-r>; <C-r>:

nnoremap <silent> <LocalLeader>ss :%sort i<CR>
vnoremap <silent> <LocalLeader>ss :sort i<CR>

nnoremap gss :echo system("stat " . shellescape(expand('%:p')) . "<bar> sed -n 4p")<CR>

nnoremap gsm :make<CR>
" Compile current file (GNU make is required).
nnoremap gsc :make %:r<CR>
" Run the compiled binary.
nnoremap gsr :!./%<<CR>

" Open a new tab with the results of a Vim command execution.
nnoremap gst :tabnew <Bar> put=execute('')<Left><Left>

noremap zea :edit ~/.dotfiles/ansible/playbook.yml<CR>
noremap zeb :edit ~/.bashrc<CR>
noremap zef :edit ~/.dotfiles/firefox/.mozilla/firefox/main/user.js<CR>
noremap zei :edit ~/.config/i3/config<CR>
noremap zer :edit ~/.config/ranger/rc.conf<CR>
noremap zet :edit ~/.tmux.conf<CR>
noremap zev :edit ~/.vimrc<CR>

nnoremap <silent> <LocalLeader>f :call FormatFile(&filetype, '%')<CR>

" }}}

" Plugin mappings {{{

" Netrw - file explorer {{{
nnoremap <silent> <Leader>ft :Texplore<CR>
nnoremap <silent> <Leader>fb :Sexplore<CR>
nnoremap <silent> <Leader>fv :Vexplore!<CR>
" }}}

" vimwiki
" headers conflicted with vinegar.
" table_mappings conflicted with UltiSnips.
let g:vimwiki_key_mappings = {
\ 'headers': 0,
\ 'table_mappings': 0,
\}
" Default is "<Leader>wt".
nmap <Leader>wT <Plug>VimwikiTabIndex
nmap <Leader>wb <Plug>VimwikiSplitLink
nmap <Leader>wv <Plug>VimwikiVSplitLink
nmap <Leader>wt <Plug>VimwikiTabnewLink
nmap glt <Plug>VimwikiToggleListItem

" git-blame.vim
nnoremap <silent> <Leader>bl :<C-u>call gitblame#echo()<CR>

" Gundo
nnoremap <Leader>gu :GundoToggle<CR>

" jedi-vim
" <Leader>d is default. Leave it here for visibility.
let g:jedi#goto_command = '<Leader>d'
" <Leader>r is default. Leave it here for visibility.
let g:jedi#rename_command = '<Leader>r'
" Default is <Leader>g.
let g:jedi#goto_assignments_command = '<Leader>ga'
" Default is <Leader>s.
let g:jedi#goto_stubs_command = '<Leader>gs'
" Default is <Leader>n.
let g:jedi#usages_command = '<Leader>gy'
" Default is <C-space> which conflicts with Tmux prefix binding.
let g:jedi#completions_command = '<C-n>'

" QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-b>']
let g:qfenter_keymap.topen = ['<C-t>']

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" fugitive
" By default, Ctrl-g prints information about current file, which
" is not useful since this information is already in lightline.
noremap <C-g>ad :Git add %<CR>
noremap <C-g>ed :Gedit<Space>
noremap <C-g>bl :Gblame<CR>
noremap <C-g>br :Gbrowse<CR>
noremap <C-g>ci :Gcommit %<CR>
noremap <C-g>co :Git checkout<Space>
" Show log for current file.
noremap <C-g>lg :0Glog<CR>
noremap <C-g>mv :Git mv <C-R>=expand('%:p')<CR> <C-R>=expand('%:p:h') . '/'<CR>
noremap <C-g>st :Gstatus<CR>
noremap <C-g>sh :Git stash<CR>
noremap <silent> <C-g>rs :silent Git reset %<CR>

" C-Left moves the cursor before ':'.
noremap <C-g>vs :Gvsplit :%<C-Left>
noremap <C-g>sp :Gsplit :%<C-Left>

" GV
noremap <Leader>gv :GV<CR>

" vim-gitgutter
nmap <C-g>hp <Plug>GitGutterPreviewHunk
nmap <C-g>hs <Plug>GitGutterStageHunk
nmap <C-g>hu <Plug>GitGutterUndoHunk
noremap <C-g>hh :GitGutterLineHighlightsToggle<CR>
" Remap hunk text object mappings from ic, ac to ih, ah,
" because ic and ac conflict with other plugins.
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerPending
xmap ah <Plug>GitGutterTextObjectOuterPending

" vim-eunuch
nnoremap <Leader><C-r> :Rename<Space>
nnoremap <Leader><C-d> :Delete<CR>
nnoremap <Leader><C-e> :SudoEdit<Space>
nnoremap <Leader><C-c> :Chmod<Space>
nnoremap <Leader><C-w> :SudoWrite<CR>

" vim-obsession
" Toggle.
nnoremap gso :Obsession!<CR>

" vim-merginal
" Requires fugitive.
noremap <silent> <Leader>m :MerginalToggle<CR>

" vZoom
nmap <Leader>z <Plug>(vzoom)

" vim-instant-markdown
noremap <LocalLeader>i :InstantMarkdownPreview<CR>

if has('python3')
  " vim-isort
  autocmd plugins FileType python packadd vim-isort
  autocmd plugins FileType python let g:vim_isort_map = '<Leader>i'
endif

" Tmuxline
let g:tmuxline_powerline_separators = 0

" ALE
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_echo_msg_format = '[%linter%] %code%: %s'
" `yaml.ansible` - custom filetype set by ansible-vim plugin.
" By default, ALE will only lint `ansible` filetype.
let g:ale_linters = {
\  'python': ['pydocstyle', 'pyflakes', 'pylint'],
\  'yaml.ansible': ['ansible-lint'],
\}

" Signature
" Highlight signs of marks based upon state indicated by vim-gitgutter.
let g:SignatureMarkTextHLDynamic = 1

" signjump
let g:signjump = {
\  'use_jumplist': 1,
\  'map_next_sign': ']g',
\  'map_prev_sign': '[g',
\  'map_last_sign': ']G',
\  'map_first_sign': '[G',
\}

" winresizer
let g:winresizer_start_key = '<Leader>R'

" UltiSnips
nnoremap <LocalLeader>u :UltiSnipsEdit<CR>

" python-syntax
let g:python_highlight_all = 1

" Tagbar
nnoremap <LocalLeader>tt :TagbarToggle<CR>

" Linediff
nnoremap [l :Linediff<CR>
nnoremap ]l :LinediffReset<CR>
vnoremap [l :Linediff<CR>
vnoremap ]l :LinediffReset<CR>

" targets.vim
" Include angle brackets in the "b" mapping.
autocmd User targets#mappings#user call targets#mappings#extend({
\  'b': {'pair': [
\    {'o':'(', 'c':')'},
\    {'o':'[', 'c':']'},
\    {'o':'{', 'c':'}'},
\    {'o':'<', 'c':'>'},]},
\})

" textobj-comment
let g:textobj_comment_no_default_key_mappings = 1
xmap ag <Plug>(textobj-comment-a)
omap ag <Plug>(textobj-comment-a)
xmap aG <Plug>(textobj-comment-big-a)
omap aG <Plug>(textobj-comment-big-a)
xmap ig <Plug>(textobj-comment-i)
omap ig <Plug>(textobj-comment-i)

" vim-swap
let g:swap_no_default_key_mappings = 1
nmap [j <Plug>(swap-prev)
nmap ]j <Plug>(swap-next)
nmap gsa <Plug>(swap-interactive)

" Splitjoin
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap zJ :SplitjoinSplit<cr>
nmap zK :SplitjoinJoin<cr>

" qfreplace
nmap cq :Qfreplace<CR>

" ALE
nmap [e <Plug>(ale_previous)
nmap ]e <Plug>(ale_next)

" fzf.vim
let g:fzf_command_prefix = 'Fzf'

" conflict-marker.vim
nnoremap gct :ConflictMarkerThemselves<CR>
nnoremap gco :ConflictMarkerOurselves<CR>
nnoremap gcb :ConflictMarkerBoth<CR>

" }}}

silent! source ~/.vimrc.local
