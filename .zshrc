# Emacsライクな操作を有効にする
# Vi ライクな操作の場合は`bindkey -v`とする
bindkey -e

# 自動補完を有効にする
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリにcdする
setopt auto_cd

# cd した先のディレクトリをディレクトリスタックに追加する
setopt auto_pushd

# pushd した時に、ディレクトリが既にスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
setopt extended_glob

# 入力したコマンドが既にコマンド履歴に含まれる場合、履歴から古い方のコマンドを削除する
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space

