#!/bin/sh


#----------------------------------------------------------------------------
# dotファイル設定
#----------------------------------------------------------------------------
dotfiles=( .bashrc .gitconfig)

for file in ${dotfiles[@]}
do
    if [ -e $HOME/$file ]; then
        if ! [ -L $HOME/$file ]; then
            ln -s $HOME/dotfiles/$file $HOME/$file.dot
            echo "Exists file. So much so that create .dot file.: $file.dot"
        fi
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
if ! [ -e $HOME/contrib ]; then
    mkdir $HOME/contrib
    echo "Create contribution directory : $HOME/contrib"
fi

#----------------------------------------------------------------------------
# Git設定
#----------------------------------------------------------------------------
if ! [ -e $HOME/contrib/git-completion.bash ]; then
    wget -O $HOME/contrib/git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash 2>/dev/null
    echo "Download : $HOME/contrib/git-completion.bash"
fi

#----------------------------------------------------------------------------
# Bash拡張設定
#----------------------------------------------------------------------------
if ! [ -e $HOME/contrib/preexec.bash ]; then
    wget -O $HOME/contrib/preexec.bash http://www.twistedmatrix.com/users/glyph/preexec.bash.txt 2>/dev/null
    echo "Download : $HOME/contrib/preexec.bash"
fi

#----------------------------------------------------------------------------
# Emacs設定
#----------------------------------------------------------------------------
# 既に設定ファイルが存在していたら削除
[ -e $HOME/.emacs ] && rm -f $HOME/.emacs
[ -e $HOME/.emacs.d ] && rm -rf $HOME/.emacs.d

# GitHubからEmacs設定をclone
if ! [ -e $HOME/.emacs.d ]; then
    git clone https://github.com/Alfr0475/Emacs.git $HOME/.emacs.d 2>/dev/null
    echo "Git clone : https://github.com/Alfr0475/Emacs.git > $HOME/.emacs.d"
fi


#----------------------------------------------------------------------------
# Ruby設定
#----------------------------------------------------------------------------
# RSense
if ! [ -e $HOME/contrib/rsense ]; then
    wget -O $HOME/contrib/rsense-0.3.tar.bz2 http://cx4a.org/pub/rsense/rsense-0.3.tar.bz2
    echo "Download : $HOME/contrib/rsense-0.3.tar.bz2"
    cd $HOME/contrib/rsense
    tar jxvfp rasense-0.3.tar.bz2 1>/dev/null
    echo "Deployment : rasense-0.3"
    mv $HOME/contrib/rsense-0.3 $HOME/contrib/rsense
    rm -rf $HOME/contrib/rsense-0.3.tar.bz2
    cd $HOME
fi

# Rubyリファレンスのダウンロード
if ! [ -e $HOME/data/rurema ]; then
    mkdir -p $HOME/data/rurema
    echo "Create data directory : $HOME/data"
fi

if ! [ -e $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829 ]; then
    wget -O $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz http://doc.ruby-lang.org/archives/201208/ruby-refm-1.9.3-dynamic-20120829.tar.gz 2>/dev/null
    echo "Download : $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz"
    cd $HOME/data/rurema
    tar zxvfp $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz 1>/dev/null
    echo "Deployment : ruby-refm-1.9.3-dynamic-20120829"
    rm -rf $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz 2>/dev/null
    cd $HOME
fi
