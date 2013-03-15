
"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for path in split(glob($VIM.'/plugins/*'), '\n')
  if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
endfor

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  if exists('$LANG') && $LANG ==# 'ja_JP.UTF-8'
    set langmenu=ja_ja.utf-8.macvim
    set encoding=utf-8
    set ambiwidth=double
  endif
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=8
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
"set list
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
set textwidth=0
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
set formatoptions=q
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
colorscheme desert " (Windows用gvim使用時はgvimrcを編集すること)

set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END
:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" ハイライトをEscで抜ける
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"対応カッコの強調OFF
let loaded_matchparen = 1

"nで検索後中央に
nmap n nzz
nmap N Nzz

" neocomplcache
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化
let g:neocomplcache_max_list = 30
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_enable_smart_case = 1
"" like AutoComplPop
let g:neocomplcache_enable_auto_select = 1
"" search with camel case like Eclipse
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_debug = 0
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
"" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"" <CR>: close popup and save indent.
"inoremap <expr><CR> neocomplcache#smart_close_popup() . (&indentexpr != '' ?
""\<C-f>\<CR>X\<BS>":"\<CR>")
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
"dictionary
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ }

"neocomplcacheのオムニ補完
autocmd FileType css,less,sass setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript,coffee setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"---------------------------------------------------------------------------
"
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running') && !has('gui_macvim')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "vimdoc-ja"'), ',')
endif

" Copyright (C) 2011 KaoriYa/MURAOKA Taro


"
" MacVim-KaoriYa固有の設定
"
let $PATH = simplify($VIM . '/../../MacOS') . ':' . $PATH
set migemodict=$VIMRUNTIME/dict/migemo-dict
set migemo

set ruler
set guioptions-=T
set transparency=5
set showtabline=2 " タブを常に表示
set nobackup
set noswapfile
set noea

if has("gui_running")
  set fuoptions=maxvert,maxhorz
  au GUIEnter * set fullscreen
endif

"ASをシンタックス
au BufNewFile,BufRead *.as set ft=actionscript

" ステータスラインの表示
set statusline=%<     " 行が長すぎるときに切り詰める位置
set statusline+=[%n]  " バッファ番号
set statusline+=%m    " %m 修正フラグ
set statusline+=%r    " %r 読み込み専用フラグ
set statusline+=%h    " %h ヘルプバッファフラグ
set statusline+=%w    " %w プレビューウィンドウフラグ
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}  
set statusline+=%y    " バッファ内のファイルのタイプ
set statusline+=\     " 空白スペース
if winwidth(0) >= 130
	set statusline+=%F    " バッファ内のファイルのフルパス
else
	set statusline+=%t    " ファイル名のみ
endif
set statusline+=%=    " 左寄せ項目と右寄せ項目の区切
set statusline+=%{fugitive#statusline()}  " Gitの
set statusline+=\ \   " 空白スペース2個
set statusline+=%1l   " 何行目にカーソルがある
set statusline+=/
set statusline+=%L    " バッファ内の総行数
set statusline+=,
set statusline+=%c    " 何列目にカーソ
set statusline+=%V    " 画面上の何列
set statusline+=\ \   " 空白スペー
set statusline+=%P    " ファイル

filetype off 
 
if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git
  call neobundle#rc(expand('~/.vim/.bundle'))
endif
 
" syntax + 自動compile
NeoBundle 'kchmck/vim-coffee-script'
" indentの深さに色を付ける
NeoBundle 'nathanaelkane/vim-indent-guides'
" git
NeoBundle 'tpope/vim-fugitive' 
" jasmine
NeoBundle 'claco/jasmine.vim'
" neocomplcache
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
" node
NeoBundle 'guileen/vim-node'

"vimfiler
NeoBundle 'Shougo/vimfiler'

"unite
NeoBundle 'git://github.com/Shougo/unite.vim.git'

"versions
NeoBundle 'git://github.com/hrsh7th/vim-versions.git'

"vimshell
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'

"vimhaml
NeoBundle "tpope/vim-haml"

"grep
NeoBundle "thinca/vim-qfreplace"
NeoBundle "fuenor/qfixgrep"

"%でタグ移動
NeoBundle "tsaleh/vim-matchit"

"nerdcommenter
NeoBundle "scrooloose/nerdcommenter"

"srround.vim
NeoBundle "tpope/vim-surround"

"vim-gitgutter
NeoBundle "airblade/vim-gitgutter"

filetype plugin on
filetype indent on

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2

"------------------------------------
" vim-coffee-script
"------------------------------------
" 保存時にコンパイル
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
let coffee_make_options = '-m'


autocmd FileType xhtml,html,ejs     setlocal sw=2 sts=2 ts=2
autocmd FileType sass    setlocal sw=2 sts=2 ts=2 et

"------------------------------------
" indent_guides
"------------------------------------
" インデントの深さに色を付ける
let g:indent_guides_start_level=2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=20
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides=1

"hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=black
au FileType coffee,ruby,javascript,python,html,sass,css IndentGuidesEnable
nmap <silent><Leader>ig <Plug>IndentGuidesToggle

"------------------------------------
"" jasmine.vim
"------------------------------------
"" ファイルタイプを変更
function! JasmineSetting()
	au BufRead,BufNewFile *Helper.js,*Spec.js  set filetype=jasmine.javascript
	au BufRead,BufNewFile *Helper.coffee,*Spec.coffee  set filetype=jasmine.coffee
	au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee  let b:quickrun_config = {'type' : 'coffee'}
	call jasmine#load_snippets()
	map <buffer> <leader>m :JasmineRedGreen<CR>
	command! JasmineRedGreen :call jasmine#redgreen()
	command! JasmineMake :call jasmine#make()
endfunction
au BufRead,BufNewFile,BufReadPre *.coffee,*.js call JasmineSetting()

"node
au FileType coffee,javascript set dictionary+=$HOME/.vim/.bundle/vim-node/dict/node.dict

"diffsplit color
set diffexpr=IgnoreSpaceDiff()
function IgnoreSpaceDiff()
	let opt = ""
	if &diffopt =~ "icase"
		let opt = opt . "-i "
	endif
	if &diffopt =~ "iwhite"
		let opt = opt . "-b "
	endif
	silent execute "!diff --ignore-all-space -a " . opt .
				\  v:fname_in . " " . v:fname_new .
				\  " > " . v:fname_out
endfunction

" Change current directory.
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>') 
function! s:ChangeCurrentDir(directory, bang)
	if a:directory == ''
		lcd %:p:h
	else
		execute 'lcd' . a:directory
	endif

	if a:bang == ''
		pwd
	endif
endfunction


"vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default=0
"現在開いているバッファをIDE風に開く
command! Of :VimFilerBufferDir -split -winwidth=45 -no-quit -toggle
nnoremap <silent> ,vf :<C-u>VimFilerBufferDir -split -winwidth=45 -no-quit -toggle<CR>
nnoremap <silent> ,vfc :<C-u>VimFilerCurrentDir -split -winwidth=45 -no-quit -toggle<CR>

"rb
autocmd FileType ruby,eruby     setlocal sw=2 sts=2 ts=2 et

" unite.vim
" " バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" " ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" " レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" " 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
nnoremap <silent> ,uv :<C-u>UniteVersions<CR>
nnoremap <silent> ,uvs :<C-u>UniteVersions status:!<CR>
nnoremap <silent> ,uvl :<C-u>UniteVersions log:%<CR>

" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q


"vimproc
let g:vimproc_dll_path = $HOME .'/.vim/.bundle/vimproc/autoload/vimproc_mac.so'
"vimshell
let g:vimshell_editor_command = '/Applications/MacPorts/MacVim.app/Contents/MacOS/Vim'
let g:vimshell_popup_height = 50
nnoremap <silent> ,vs :<C-u>VimShellPop<CR>
nnoremap <silent> ,vsc :<C-u>VimShellCurrentDir -popup<CR>
nnoremap <silent> ,vsb :<C-u>VimShellBufferDir -popup<CR>

"vimにejsをhtmlとして認識させる
au BufRead,BufNewFile,BufReadPre *.ejs   set filetype=html

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
"imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2 concealcursor=i
endif

runtime macros/matchit.vim

"nerdcommenter
let NERDSpaceDelims = 1
let NERDShutUp = 1
let g:NERDCreateDefaultMappings = 0
nmap <silent> ,cc <Plug>NERDCommenterToggle
vmap <silent> ,cc <Plug>NERDCommenterToggle
nmap <silent> ,cu <Plug>NERDCommenterUncommentLine
vmap <silent> ,cu <Plug>NERDCommenterUncommentLine
vmap <silent> ,cs <Plug>NERDCommenterSexy
