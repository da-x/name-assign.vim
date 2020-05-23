" Maintainer:   Dan Aloni <alonid@gmail.com>

if get(g:,'autoloaded_nameassign','0')
    finish
endif
let g:autoloaded_nameassign = 1

function! s:GetVisualSelectionLines() abort
    " Why is this not a built-in Vim script function?!
    " https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

function! s:Settle() range abort
    if !get(b:, "name_assign_mode", v:false)
        " Not active. This is bizarre.
        return
    endif

    for l:map in get(g:name_assign_mode_maps, "settle", [])
        exec "nunmap <buffer> ".l:map
        exec "vunmap <buffer> ".l:map
    endfor
    for l:map in get(g:name_assign_mode_maps, "up", [])
        exec "vunmap <buffer> ".l:map
    endfor
    for l:map in get(g:name_assign_mode_maps, "down", [])
        exec "vunmap <buffer> ".l:map
    endfor
    let b:name_assign_mode = v:false

    normal! \<Esc>\<Esc>
    call setpos(".", [0, b:name_assign_line, 0])
    normal! $
endfunction

function! s:Shift(arg) range abort
    if a:arg == 1
        '<,'>move '>+1
    else
        '<,'>move '<-2
    endif

    normal! gv=gv
endfunction

function! nameassign#Call() abort range
    let l:filetype_settings = get(g:name_assign_filetypes, &filetype, {})
    if len(l:filetype_settings) == 0
        echo "Not supported"
        return
    endif
    if get(b:, "name_assign_mode", v:false)
        " Already active. Recursive activation should not happen.
        return
    endif

    let l:prefix = get(l:filetype_settings, "prefix", "")
    let l:suffix = get(l:filetype_settings, "suffix", "")

    let l:needs_name = stridx(l:prefix, "%s") != -1 || stridx(l:suffix, "%s") != -1
    let l:needs_type = stridx(l:prefix, "%t") != -1 || stridx(l:suffix, "%t") != -1

    if l:needs_name
        let l:name = input('Enter name: ')
        let l:prefix = substitute(l:prefix, '%s', l:name, '')
        let l:suffix = substitute(l:suffix, '%s', l:name, '')
    endif
    if l:needs_type
        let l:type = input('Enter type: ')
        let l:prefix = substitute(l:prefix, '%t', l:type, '')
        let l:suffix = substitute(l:suffix, '%t', l:type, '')
    endif

    let [_, l:line_a, l:col_a, _ ] = getpos("'<")
    let [_, l:line_b, l:col_b, _ ] = getpos("'>")
    let l:selection = s:GetVisualSelectionLines()

    let b:name_assign_line = l:line_b + 1
    let b:name_assign_text = l:name
    execute "normal! gvd"
    call setpos(".", [0, l:line_a, l:col_a])
    execute "silent normal! i\<C-r>\<C-r>=b:name_assign_text\<CR>\<Esc>"
    let @@ = b:name_assign_text

    let l:index = 0
    for l:line in l:selection
        if l:index == 0
            let l:added_line = l:prefix
        else
            let l:added_line = "    "
        endif

        let l:added_line .= l:line

        if l:index + 1 == len(l:selection)
            let l:added_line .= l:suffix
        endif

        call append(l:line_a - 1 + l:index, l:added_line)
        let l:index = l:index + 1
    endfor

    for l:i in [1, 2]
        call setpos(".", [0, l:line_a + len(l:selection) - 1, 0])
        normal! $
        let [_, _, l:lastcol, _ ] = getpos(".")

        call setpos("'<", [0, l:line_a, 0])
        call setpos("'>", [0, l:line_a + len(l:selection) - 1, l:lastcol])
        normal! gv
        if l:i == 1
            normal! =
        endif
    endfor

    let b:name_assign_mode = v:true
    for l:map in get(g:name_assign_mode_maps, "settle", [])
        exec "nnoremap <silent><buffer> ".l:map." :call <SID>Settle()<CR>"
        exec "vnoremap <silent><buffer> ".l:map." :call <SID>Settle()<CR>"
    endfor
    for l:map in get(g:name_assign_mode_maps, "up", [])
        exec "vnoremap <silent><buffer> ".l:map." :call <SID>Shift(-1)<CR>"
    endfor
    for l:map in get(g:name_assign_mode_maps, "down", [])
        exec "vnoremap <silent><buffer> ".l:map." :call <SID>Shift(1)<CR>"
    endfor
endfunction

" vim: set et sw=4 sts=4 ts=8:
