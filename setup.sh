#!/bin/sh



#----------------------------------------------------------------------------
# Configure
#----------------------------------------------------------------------------
RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

#----------------------------------------------------------------------------
# Common関数群
#----------------------------------------------------------------------------
function echo_success() {
    $MOVE_TO_COL
    echo -n "["
    $SETCOLOR_SUCCESS
    echo -n $"  OK  "
    $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}

function echo_failure() {
    $MOVE_TO_COL
    echo -n "["
    $SETCOLOR_FAILURE
    echo -n $"FAILED"
    $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}

function echo_passed() {
    $MOVE_TO_COL
    echo -n "["
    $SETCOLOR_WARNING
    echo -n $"PASSED"
    $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}

function echo_warning() {
    $MOVE_TO_COL
    echo -n "["
    $SETCOLOR_WARNING
    echo -n $"WARNING"
    $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}

#----------------------------------------------------------------------------
# dotファイル設定
#----------------------------------------------------------------------------
dotfiles=( .bashrc .bash_profile .gitconfig)

for file in ${dotfiles[@]}
do
    echo -n $file
    if [ -e $HOME/$file ]; then
        if ! [ -L $HOME/$file ]; then
            echo_passed
            ln -s $HOME/dotfiles/$file $HOME/$file.dot
            echo "Exists file. So much so that create .dot file.: $file.dot"
            echo
        fi
    else
        echo_success
        echo
        ln -s $HOME/dotfiles/$file $HOME/$file
    fi
done

# Gitがインストールされて無かったら終了する。
# 以降のスクリプトはGitHub前提のスクリプト。
if ! [ `type -P git` ]; then
    echo -n "Install git"
    echo_failure
    echo
    exit 0
fi

# 外部提供のスクリプト置き場作成
if ! [ -e $HOME/contrib ]; then
    mkdir $HOME/contrib
fi

#----------------------------------------------------------------------------
# Git設定
#----------------------------------------------------------------------------
if ! [ -e $HOME/contrib/git-completion.bash ]; then
    echo -n "git-completion.bash"
    wget -O $HOME/contrib/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --no-check-certificate 2>/dev/null
    if [ $? -eq 0 ]; then
        echo_success
        echo
    else
        echo_failure
        echo
    fi
fi

#----------------------------------------------------------------------------
# Bash拡張設定
#----------------------------------------------------------------------------
if ! [ -e $HOME/contrib/preexec.bash ]; then
    echo -n "preexec.bash"
    wget -O $HOME/contrib/preexec.bash http://www.twistedmatrix.com/users/glyph/preexec.bash.txt 2>/dev/null
    if [ $? -eq 0 ]; then
        echo_success
        echo
    else
        echo_failure
        echo
    fi
fi

#----------------------------------------------------------------------------
# Emacs設定
#----------------------------------------------------------------------------
# 既に設定ファイルが存在していたら削除
[ -e $HOME/.emacs ] && rm -f $HOME/.emacs
[ -e $HOME/.emacs.d ] && rm -rf $HOME/.emacs.d

# GitHubからEmacs設定をclone
if ! [ -e $HOME/.emacs.d ]; then
    echo -n "Cloning into '$HOME/.emacs.d'..."
    git clone https://github.com/Alfr0475/Emacs.git $HOME/.emacs.d 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ]; then
        echo_success
        echo
    else
        echo_failure
        echo
    fi
fi

#----------------------------------------------------------------------------
# Vim設定
#----------------------------------------------------------------------------
[ -e $HOME/.vim ] && rm -rf $HOME/.vim

# GitHubからVim設定をclone
if ! [ -e $HOME/.vim ]; then
    echo -n "Cloning into '$HOME/.vim'..."
    git clone https://github.com/Alfr0475/Vim.git $HOME/.vim 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ]; then
        echo_success
        echo
    else
        echo_failure
        echo
    fi
fi

#----------------------------------------------------------------------------
# Ruby設定
#----------------------------------------------------------------------------
# RSense
if ! [ -e $HOME/contrib/rsense ]; then
    wget -O $HOME/contrib/rsense-0.3.tar.bz2 http://cx4a.org/pub/rsense/rsense-0.3.tar.bz2 2>/dev/null
    (cd $HOME/contrib && tar jxvfp $HOME/contrib/rsense-0.3.tar.bz2 1>/dev/null)
    mv $HOME/contrib/rsense-0.3 $HOME/contrib/rsense
    rm -rf $HOME/contrib/rsense-0.3.tar.bz2
    cd $HOME
fi

# Rubyリファレンスのダウンロード
if ! [ -e $HOME/data/rurema ]; then
    mkdir -p $HOME/data/rurema
fi

if ! [ -e $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829 ]; then
    wget -O $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz http://cache.ruby-lang.org/pub/ruby/doc/ruby-refm-1.9.3-dynamic-20120829.tar.gz 2>/dev/null
    (cd $HOME/data/rurema && tar zxvfp $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz 1>/dev/null)
    rm -rf $HOME/data/rurema/ruby-refm-1.9.3-dynamic-20120829.tar.gz 2>/dev/null
fi
