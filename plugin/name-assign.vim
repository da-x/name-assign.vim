" name-assign.vim - A helper around extracting expressions to assignments
"
" Maintainer:   Dan Aloni <alonid@gmail.com>

if exists("g:loaded_name_assign") || &cp || v:version < 700
    finish
endif

let g:loaded_name_assign = 1
let g:name_assign_filetypes = {
  \    "rust": {
  \        "prefix" : "let %s = ",
  \        "suffix" : ";",
  \    },
  \    "javascript": {
  \        "prefix" : "let %s = ",
  \        "suffix" : ";",
  \    },
  \    "vim": {
  \        "prefix" : "let %s = ",
  \    },
  \    "cpp": {
  \        "prefix" : "auto %s = ",
  \        "suffix" : ";",
  \    },
  \    "c": {
  \        "prefix" : "%t %s = ",
  \        "suffix" : ";",
  \    },
  \    "python": {
  \        "prefix" : "%s = ",
  \    },
  \    "go": {
  \        "prefix" : "%s := ",
  \    },
  \}

let s:maps_defaults = {
  \    "up"     : ["<Up>", "k"],
  \    "down"   : ["<Down>", "j"],
  \    "settle" : ["<Return>", "<Esc>"],
  \}

let g:name_assign_mode_maps =
    \ extend(copy(s:maps_defaults), get(g:, "name_assign_mode_maps", {}))

command! -range -nargs=* NameAssign :<line1>,<line2>call nameassign#Call()
vnoremap <silent> <Plug>NameAssign :NameAssign<cr>

if !hasmapto('<Plug>NameAssign', 'v') && (mapcheck("<A-=>", "v") == "")
    vmap <silent> <A-=> <Plug>NameAssign
endif

" vim: set et sw=4 sts=4 ts=8:
