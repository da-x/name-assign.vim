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
  \}

if !exists("g:name_assign_no_mappings") || !g:name_assign_no_mappings
    command! -range -nargs=* NameAssign :<line1>,<line2>call nameassign#Call()
    vnoremap <A-=> :NameAssign<CR>
endif

" vim: set et sw=4 sts=4 ts=8:
