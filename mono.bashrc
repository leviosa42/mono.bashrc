#!/usr/bin/bash

set -o pipefail

# [[ -v 'PS1' ]] || return 0
[[ ! $- =~ 'i' ]] && return 0

function _main() { # {{{
	# _set_ls_colors
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
		export PS1="${res}(${exitcolor}${shell_name} ${SHLVL}${res}${bg})${yel}\w${res}:\\$ ${bg_a}"
} # }}}

function _set_ls_colors() { # {{{
	export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
} # }}}

function colortheme() { # {{{
	case $@ in
		'monokai') # {{{
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
	cat - <<- 'EOF'
		" * PreInit
		set encoding=utf-8
		scriptencoding utf-8
		if &compatible | set nocompatible | endif
		syntax off
		filetype off
		filetype plugin indent off

		set fileformat=unix
		set fileformats=unix,dos
		set clipboard+=unnamed,unnamedplus

		set hidden

		set incsearch
		set ignorecase
		set smartcase
		set hlsearch
		set wildmenu

		set wildmode=longest:list,full
		set mouse=a
		set whichwrap=b,s,<,>,[,]
		set timeout
		set timeoutlen=2000
		set ttimeoutlen=-1

		set backspace=indent,eol,start

		set noexpandtab
		set tabstop=4
		set softtabstop=-1 shiftwidth=0
		set autoindent
		set smartindent
		set number
		set cursorline
		set showcmd
		set showmatch
		if has('termguicolors') && !has('gui_running')
		  set termguicolors
		endif
		set ambiwidth=single

		set list
		set listchars=
		set listchars+=tab:>\ 
		set listchars+=trail:~
		set listchars+=nbsp:%
		"set listchars+=eol:$
		set listchars+=extends:»
		set listchars+=precedes:«
		"set listchars+=space:·

		set fillchars+=vert:┃ " U+2503
		set fillchars+=vert:│ " U+2502
		set fillchars+=foldclose:>
		set fillchars+=foldopen:┌ " U+250C
		set fillchars+=foldsep:│ " U+2502
		set fillchars+=eob:\ 
		
		set laststatus=2
		set ruler
		set showmode

		syntax enable
		set background=dark
		filetype on
		filetype plugin indent on
		" vim: ft=vim et ts=2 sts=-1 sw=0 fdm=marker fmr={{{,}}}
	EOF
} # }}}

_main
# vim: ft=sh noet ts=2 sts=-1 sw=0 fdm=marker fmr={{{,}}}
