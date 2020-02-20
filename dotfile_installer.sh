#!/bin/zsh

function helpmsg() {
  command echo "Usage: $0 [link | update]" 0>&2
  command echo ""
}

function main() {
  local link="false"
  local update="false"

  if [ $# = 0 ];then
    update="true"
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
    ln -s $HOME/dotfiles/.zprofile $HOME/.zprofile
		ln -s $HOME/dotfiles/.zsh $HOME/.zsh
    ln -s $HOME/dotfiles/.vim $HOME/.vim
    ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
		cp $HOME/dotfiles/.zshrc $HOME/.zshrc
  fi
  if [[ "$update" = true ]];then
    unlink $HOME/.vimrc
    unlink $HOME/.zprofile
    unlink $HOME/.vim
    unlink $HOME/.tmux.conf
		unlink $HOME/.zsh
    ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
    ln -s $HOME/dotfiles/.zprofile $HOME/.zprofile
    ln -s $HOME/dotfiles/.vim $HOME/.vim
    ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
		ln -s $HOME/dotfiles/.zsh $HOME/.zsh
  fi
}

main "$@"
				
