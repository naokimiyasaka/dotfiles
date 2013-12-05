#!/bin/sh


#----------------------------------------------------------------------------
# dotファイル設定
#----------------------------------------------------------------------------
dotfiles=( .bashrc .screenrc .gitconfig)

for file in ${dotfiles[@]}
do
  if [ -a $HOME/$file ]; then
    ln -s $HOME/dotfiles/$file $HOME/$file.dot
    echo "Exists file. So much so that create .dot file.: $file.dot"
  else
    ln -s $HOME/dotfiles/$file $HOME/$file
    echo "Create symbolic link : $file"
  fi
done

echo

# Gitがインストールされて無かったら終了する。
# 以降のスクリプトはGitHub前提のスクリプト。
! [ `type -P git` ] && exit 0

# 外部提供のスクリプト置き場作成
! [ -a $HOME/contrib ] && mkdir $HOME/contrib
echo "Create contribution directory : $HOME/contrib"

#----------------------------------------------------------------------------
# Git設定
#----------------------------------------------------------------------------
wget -O $HOME/contrib/git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash 2>/dev/null
echo "Download : $HOME/contrib/git-completion.bash"

#----------------------------------------------------------------------------
# Bash拡張設定
#----------------------------------------------------------------------------
wget -O $HOME/contrib/preexec.bash http://www.twistedmatrix.com/users/glyph/preexec.bash.txt 2>/dev/null
echo "Download : $HOME/contrib/preexec.bash"

#----------------------------------------------------------------------------
# Emacs設定
#----------------------------------------------------------------------------
# 既に設定ファイルが存在していたら削除
[ -a $HOME/.emacs ] && rm -f $HOME/.emacs
[ -a $HOME/.emacs.d ] && rm -rf $HOME/.emacs.d

# GitHubからEmacs設定をclone
git clone https://github.com/Alfr0475/Emacs.git $HOME/.emacs.d 2>/dev/null
echo "Git clone : https://github.com/Alfr0475/Emacs.git > $HOME/.emacs.d"
