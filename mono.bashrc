#!/usr/bin/bash

set -o pipefail

# [[ -v 'PS1' ]] || return 0
[[ ! $- =~ 'i' ]] && return 0

function _main() { # {{{
	_set_alias
	_set_prompt
} # }}}

function _set_alias() { # {{{
	# Aliases to avoid mistakes
	alias rm='rm -i'
	alias mv='mv -i'
	alias cp='cp -i'

	# ls
	if [[ $(command ls --help 2>&1) =~ 'BusyBox' ]]; then
		alias ls='ls -1F --color=auto'
	else
		alias ls='ls -1 -F --sort=extension --color=auto'
	fi
	alias ll='ls -lh'
	alias la='ls -la'

	# eza
	# https://github.com/eza-community/eza
	if [[ $(command -v eza) ]]; then
		alias __eza__="$(which eza)"
		alias eza='__eza__ --color=automatic -1F --group-directories-first -h --git --time-style=long-iso'
		alias ls='eza'
		alias ll='ls -l'
		alias la='ls -laa'
		alias lt="eza -a -T -L=3 -I='node_modules|.git|.cache'"
	fi

	# grep, fgrep, egrep
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'

	alias e="$EDITOR"
	alias vi='vim -u NONE'

	alias :q='exit'
	alias q='exit'

	alias cls=clear
	alias clc=clear
} # }}}

function _set_prompt() { # {{{
		local exst=$? # exit status

		#	 COLOR			FG	 |	 BG
		# --------------------------
		# black .... \e[30m | \e[40m
		# red ...... \e[31m | \e[41m
		# green .... \e[32m | \e[42m
		# yellow ... \e[33m | \e[43m
		# blue	.... \e[34m | \e[44m
		# magenta .. \e[35m | \e[45m
		# cyan ..... \e[36m | \e[46m
		# white .... \e[37m | \e[47m

		# reset .... \e[00m

		local red="$(echo -e '\[\e[31m\]')"
		local yel="$(echo -e '\[\e[33m\]')"
		local cya="$(echo -e '\[\e[36m\]')"
		local res="$(echo -e '\[\e[00m\]')"
		local bg="$(echo -e '\[\e[49m\]')"
		local bg_a="$(echo -e '\[\e[45m\]')"
		# \s .. shell name

		# shell_name
		local shell_name='\s'
		# exitcolor
		if [[ $exst == 0 ]]; then
			local exitcolor=$cya
		else
			local exitcolor=$red
		fi

		if [[ -v WSL_DISTRO_NAME ]]; then
				shell_name="wsl:${shell_name}"
		fi

		if [ -e /.dockerenv ]; then
			shell_name="docker:${shell_name}"
		fi

		# export PS1="(\s $SHLVL)\[\e[1;33m\]\w\[\e[00m\]\$ "
		export PS1="${res}(${exitcolor}${shell_name} ${SHLVL}${res}${bg})${yel}\w${res}:\\$ "
} # }}}

function colortheme() { # {{{
	case $@ in
		'monokai') # {{{
			local monokai=$(cat - <<- 'EOF'
				echo -ne '\e]10;#f8f8f2\e\\'; # foreground
				echo -ne '\e]11;#2e2e2e\e\\'; # background
				echo -ne '\e]4;00;#1b1d1e\e\\'; # 0:black
				echo -ne '\e]4;01;#f92672\e\\'; # 1:red
				echo -ne '\e]4;02;#82b414\e\\'; # 2:green
				echo -ne '\e]4;03;#fd971f\e\\'; # 3:yellow
				echo -ne '\e]4;04;#465457\e\\'; # 4:blue
				echo -ne '\e]4;05;#8c54fe\e\\'; # 5:purple
				echo -ne '\e]4;06;#56c2df\e\\'; # 6:cyan
				echo -ne '\e]4;07;#ccccc6\e\\'; # 7:white
				echo -ne '\e]4;08;#505354\e\\'; # 8:black+
				echo -ne '\e]4;09;#ff5994\e\\'; # 1:red+
				echo -ne '\e]4;10;#b6e354\e\\'; # 2:green+
				echo -ne '\e]4;11;#feed6c\e\\'; # 3:yellow+
				echo -ne '\e]4;12;#899ca1\e\\'; # 4:blue+
				echo -ne '\e]4;13;#9e6ffe\e\\'; # 5:purple+
				echo -ne '\e]4;14;#8cedff\e\\'; # 6:cyan+
				echo -ne '\e]4;15;#f8f8f2\e\\'; # 7:white+
			EOF
			)
			echo -e $monokai
			;; # }}}
		'ubuntu') # {{{
			echo -ne '\e]10;#ffffff\e\\' # foreground
			echo -ne '\e]11;#300a24\e\\' # background
			echo -ne '\e]4;00;#171421\e\\' # 0:black
			echo -ne '\e]4;01;#c21a23\e\\' # 1:red
			echo -ne '\e]4;02;#26a269\e\\' # 2:green
			echo -ne '\e]4;03;#a2734c\e\\' # 3:yellow
			echo -ne '\e]4;04;#0037da\e\\' # 4:blue
			echo -ne '\e]4;05;#881798\e\\' # 5:purple
			echo -ne '\e]4;06;#3a96dd\e\\' # 6:cyan
			echo -ne '\e]4;07;#cccccc\e\\' # 7:white
			echo -ne '\e]4;08;#767676\e\\' # 8:black+
			echo -ne '\e]4;09;#c01c28\e\\' # 1:red+
			echo -ne '\e]4;10;#26a269\e\\' # 2:green+
			echo -ne '\e]4;11;#a2734c\e\\' # 3:yellow+
			echo -ne '\e]4;12;#08458f\e\\' # 4:blue+
			echo -ne '\e]4;13;#a347ba\e\\' # 5:purple+
			echo -ne '\e]4;14;#2c9fb3\e\\' # 6:cyan+
			echo -ne '\e]4;15;#f2f2f2\e\\' # 7:white+
			;; # }}}
	esac
} # }}}

function _out_vimrc() { # {{{
	cat - <<- 'VIMRC_EOF'
	" * Pre Init {{{
	set encoding=utf-8
	scriptencoding utf-8
	if &compatible | set nocompatible | endif
	syntax off
	filetype off
	filetype plugin indent off

	let $MYVIMRC = expand('<sfile>')
	set modeline
	set modelines=2
	" * }}}

	" * Editing {{{
	set fileformat=unix
	set fileformats=unix,dos
	set backspace=indent,eol,start
	"  * }}}

	" * Indentation {{{
	set noexpandtab
	set tabstop=4
	set softtabstop=-1 shiftwidth=0 " follow tabstop
	set autoindent
	set smartindent
	" * }}}

	" * Searching {{{
	set incsearch " incremental search
	set ignorecase " ignore case
	set smartcase " ignore case if search pattern is all lowercase
	set hlsearch " highlight search results
	set wildmenu
	set wildignore+=*/.git/* " ignore .git directory
	" * * }}}

	" * General {{{
	set wildmode=longest:list,full " command-line completion mode
	set mouse=a " enable mouse
	set clipboard+=unnamed,unnamedplus " use system clipboard
	set whichwrap=b,s,<,>,[,] " move cursor to next line
	set timeout
	set timeoutlen=2000
	set ttimeoutlen=-1
	" * }}}

	" * Appearance {{{
	set number
	set cursorline
	set showcmd
	set showmatch
	if has('termguicolors') && !has('gui_running')
		set termguicolors
	endif
	set ambiwidth=single
	" * * listchars {{{
	set list 
	set listchars=
	set listchars+=tab:>\ 
	set listchars+=trail:~
	set listchars+=nbsp:%
	"set listchars+=eol:$
		set listchars+=extends:»
		set listchars+=precedes:«
	"set listchars+=space:·
	" * * }}}
	" * * fillchars {{{
	set fillchars+=vert:┃ " U+2503
	set fillchars+=vert:│ " U+2502
	if v:version > 800
		set fillchars+=foldclose:>
		set fillchars+=foldopen:┌ " U+250C
		set fillchars+=foldsep:│ " U+2502
		set fillchars+=eob:\ 
	endif
	" * * }}}
	set laststatus=2
	set ruler
	set showmode
	" * }}}

	" * Keymap {{{
	" * * Misc {{{
	let g:mapleader = "\<Space>"

	inoremap <silent> jk <Esc>

	" ref: https://github.com/nvim-zh/minimal_vim
	nnoremap <silent><expr> j (v:count == 0 ? 'gj' : 'j')
	nnoremap <silent><expr> k (v:count == 0 ? 'gk' : 'k')
	nnoremap <silent><expr> J (v:count == 0 ? '3gj' : '3j')
	nnoremap <silent><expr> K (v:count == 0 ? '3gk' : '3k')

	" u <-> U == undo <-> redo
	nnoremap <silent> U <C-r>
	nnoremap <silent> <C-r> U

	" Insert hard tab
	inoremap <S-Tab> <C-v><Tab>

	" Move {cursorline/visual selection} {up/down}
	nnoremap <silent> <S-Up> "zdd<Up>"zP
	nnoremap <silent> <S-Down> "zdd"zp
	vnoremap <silent> <S-Up> "zx<Up>"zP`[V`]
	vnoremap <silent> <S-Down> "zx"zp`[V`]

	" Do not use resister by x
	nnoremap x "_x
	" * * }}}
	" * * [buffer]: {{{
	nmap <Leader>b [buffer]
	nnoremap [buffer] <Nop>
	nnoremap [buffer]n :<C-u>new<CR>
	nnoremap [buffer]k :<C-u>bprev<CR>
	nnoremap [buffer]j :<C-u>bnext<CR>
	nnoremap [buffer]l :<C-u>ls<CR>
	nnoremap [buffer]L :<C-u>ls!<CR>
	" * * }}}
	" * * [window]: {{{
	nmap <Leader>w [window]
	noremap [window] <Nop>
	nnoremap [window]h <C-w>h
	nnoremap [window]j <C-w>j
	nnoremap [window]k <C-w>k
	nnoremap [window]l <C-w>l
	nnoremap [window]s :<C-u>split<CR>
	nnoremap [window]v :<C-u>vsplit<CR>
	nnoremap [window]o :<C-u>only<CR>
	" * * }}}
	" * * [tab]: {{{
	nmap <Leader>t [tab]
	nnoremap [tab] <Nop>
	nnoremap [tab]h :<C-u>tabprevious<CR>
	nnoremap [tab]l :<C-u>tabnext<CR>
	nnoremap [tab]n :<C-u>tabnew<CR>
	" * * }}}
	" * * [terminal]: {{{
	nmap <Leader>x [terminal]
	nnoremap [terminal] <Nop>
	nnoremap [terminal]x :<C-u>terminal ++curwin<CR>
	nnoremap [terminal]h :<C-u>vertical aboveleft terminal<CR>
	nnoremap [terminal]j :<C-u>rightbelow terminal<CR>
	nnoremap [terminal]k :<C-u>aboveleft terminal<CR>
	nnoremap [terminal]l :<C-u>vertical rightbelow terminal<CR>
	nnoremap [terminal]H :<C-u>vertical topleft terminal<CR>
	nnoremap [terminal]J :<C-u>botright terminal<CR>
	nnoremap [terminal]K :<C-u>topleft terminal<CR>
	nnoremap [terminal]L :<C-u>vertical botright terminal<CR>
	nnoremap [terminal]t :<C-u>tab terminal<CR>

	" ref: https://qiita.com/gorilla0513/items/f59e54606f6f4d7e3514
	command! Terminal call popup_create(term_start([&shell], #{ hidden: 1, term_finish: 'close'}), #{ border: [], minwidth: winwidth(0)/2, minheight: &lines/2 })
	nnoremap [terminal]p :<C-u>Terminal<CR>
	" * * }}}
	" * * [setting]: {{{
	nmap <Leader>v [vimrc]
	nnoremap [vimrc] <Nop>
	nnoremap [vimrc]s :<C-u>source $MYVIMRC<CR>
	nnoremap [vimrc]e :<C-u>edit $MYVIMRC<CR>
	nnoremap [vimrc]t :<C-u>tabnew $MYVIMRC<CR>
	" * * }}}
	" * * [comment]: {{{
	function! InsertCommentString()
		let line = getline('.')
		let lineNum = line('.')
		call setline(lineNum, printf(&cms, line))
	endfunction

	function! CommentIn() abort
		" ref: https://vim-jp.org/vim-users-jp/2009/09/20/Hack-75.html
		" \%(^\s*\|^\t*\)\@<=\S
		let l = getline('.')
		if l == ''
			call setline(line('.'), printf(&cms, ''))
		else
			call setline(line('.'), substitute(getline('.'), '\%(^\s*\|^\t*\)\@<=\(\S.*\)', printf(&cms, '\1'), ''))
			"echo substitute(getline('.'), '\%(^\s*\|^\t*\)\@<=\(\S.*\)', '" \1', '')
		endif
	endfunction

	function CommentOut() abort
		let l = getline('.')
		if l == printf(&cms, '')
			call setline(line('.'), '')
		else
			"echo substitute(getline('.'), printf(&cms, ''), '', '')
			call setline(line('.'), substitute(getline('.'), printf(&cms, ''), '', ''))
		endif
	endfunction

	nmap <Leader>c [comment]
	nnoremap [comment] <Nop>
	nnoremap [comment]i :call CommentIn()<CR>
	nnoremap [comment]o :call CommentOut()<CR>
	"nnoremap <expr>[comment] I<C-r>=printf(&cms, '')<CR><Esc>
	" * * }}}
	" * * command-line: {{{
	cnoremap <C-p> <Up>
	cnoremap <C-n> <Down>
	cnoremap <C-b> <Left>
	cnoremap <C-f> <Right>
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	cnoremap <C-d> <Del>
	" * * }}}
	" * }}}

	" * Post Init {{{
	syntax enable
	set background=dark
	filetype on
	filetype plugin indent on
	" * }}}
	" vim: ft=vim et ts=2 sts=-1 sw=0 fdm=marker fmr={{{,}}}
	VIMRC_EOF
} # }}}

function osc() { # {{{
  # Usage:
  #   osc <sequence_number> <text>
  # Example:
  #   osc 1 'This is title' # == printf "\033]1;This is title\033\\"
	[[ $1 =~ 'd' ]] && set -x
  local IFS=';'
  printf "\033]$*\033\\"
	[[ $1 =~ 'd' ]] && set +x
	
  return 0
} # }}}

function colortest() { # {{{
# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
  local T='gYw' # The test text
  echo -e "\n                 40m     41m     42m     43m\
       44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
} # }}}
_main
# vim: ft=sh noet ts=2 sts=-1 sw=0 fdm=marker fmr={{{,}}}
