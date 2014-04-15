" Vim7.3以下の場合、~/.vim/vimrcを設定ファイルとして認識しない
" なので、7.3以下だった場合は~/.vimrcで~/.vim/vimrcを読みにいく
if v:version < 704
  let s:from_legacy_vimrc = expand('~/.vim/vimrc')
  if filereadable(s:from_legacy_vimrc)
    execute 'source ' . s:from_legacy_vimrc
  endif
endif

