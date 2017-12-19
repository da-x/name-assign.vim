if exists("g:loaded_name_assign") || &cp || v:version < 700
  finish
endif
let g:loaded_name_assign = 1

"
" Common in many programming languages, the next function and bindings automate
" the task of moving a visually marked expression into a marker right next to an
" uninitialized programming language variable, replacing the marked expression
" with the variable's name.
"
" To illustrate, suppose we have some mark 'k' right next to 'int i',
" and we want to move _marked_ expression to it;
"
"    int i<mark_k_here>;
"    ...
"    call_func(some_code, _marked_);
"
" After <leader>k, below, the result will be:
"
"    int i = _marked_;
"     ...
"    call_func(some_code, i);
"
" Currently this does not support multi-line visually marked expressions.
"

function! s:use_assigned_name(marker) range
  let l:visual_selection = s:get_visual_selection()
  let l:mark_s = getpos("'<")
  let l:mark_e = getpos("'>")
  if l:mark_s[1] == l:mark_e[1]
    let l:line = getline(l:mark_s[1])
    let l:curpos = getcurpos()
    let l:mark = getpos("'".a:marker)
    let l:mark[2] = l:mark[2] - 1
    let l:aline = getline(l:mark[1])
    call setpos(".", l:mark)
    let l:word = expand("<cword>")
    call setpos(".", l:curpos)

    call setline(l:mark_s[1],
          \ strpart(l:line, 0, l:mark_s[2] - 1)
          \ . l:word
          \ . strpart(l:line, l:mark_e[2]))
    call setline(l:mark[1],
          \ strpart(l:aline, 0, l:mark[2])
          \ . " = " . l:visual_selection
          \ . strpart(l:aline, l:mark[2]))
    let l:mark_s[2] = l:mark_s[2] + strlen(l:word)
    call setpos(".", l:mark_s)
  endif
endfunction

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

if !exists("g:name_assign_no_mappings") || ! g:name_assign_no_mappings
  command! -range -nargs=* UseAssignedName :<line1>,<line2>call <SID>use_assigned_name(<f-args>)
  map <Esc>= mk
  imap <Esc>= <C-c><right><Esc>=
  xnoremap <Esc>= :UseAssignedName k<cr>
endif
