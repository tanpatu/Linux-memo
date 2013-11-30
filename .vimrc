
set title "編集中のファイル名を表示
set tabstop=4 "インデントをスペース4つ分に設定
set background=dark

"------------------------------------------------------------------------------
"タブページ表示・移動のカスタマイズ
"------------------------------------------------------------------------------

"Anywhere SID.

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


"------------------------------------------------------------------------------
"挿入モード時、アクティブタブの色を変更 TabLineSel
"------------------------------------------------------------------------------

let g:hi_insert = 'highlight TabLineSel guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:TabLineSel('Enter')
    autocmd InsertLeave * call s:TabLineSel('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:TabLineSel(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('TabLineSel')
    silent exec g:hi_insert
  else
    highlight clear TabLineSel
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

"------------------------------------------------------------------------------
"その他の設定
"------------------------------------------------------------------------------

" Spaceキーで画面スクロール
nnoremap <SPACE>   <PageDown>
" " Shift+Spaceキーで画面逆スクロール
nnoremap <C-SPACE> <PageUp>

" 強制全保存終了を無効化
nnoremap ZZ <Nop>

"ctrl+t で新しいタブを開いて編集するファイル名の入力を待つ
nnoremap <C-T> :tabe<CR>:e<SPACE>

" ctrl+tab, ctrl+shift+tab でタブ切り替え

nnoremap <C-Tab>   gt
nnoremap <C-S-Tab> gT

"------------------------------------------------------------------------------

