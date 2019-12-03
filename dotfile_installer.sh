#!/bin/bash

function helpmsg() {
  command echo "Usage: $0 [link | update]" 0>&2
	command echo ""
}

function main() {
	local link="false"
	local update="false"

  if [ $# = 0 ];then
    link="true"
	fi

  while [ $# -gt 0 ];do
    case ${1} in
      --help|-h)
			  helpmsg
				exit 1
				;;
			link)
				link="true"
				;;
			update)
				update="true"
				;;
			*)
			  echo "[ERROR] Invalied arguments '${1}'"
				helpmsg
				exit 1
				;;
		esac
		shift
  done

	if [[ "$link" = true ]];then
 	  ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
    ln -s $HOME/dotfiles/.bash_profile $HOME/.bash_profile
		ln -s $HOME/dotfiles/.vim $HOME/.vim
  fi
	if [[ "$update" = true ]];then
		unlink $HOME/.vimrc
		unlink $HOME/.bash_profile
		unlink $HOME/.vim
	  ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
    ln -s $HOME/dotfiles/.bash_profile $HOME/.bash_profile
		ln -s $HOME/dotfiles/.vim $HOME/.vim
	fi

}

main "$@"
				
