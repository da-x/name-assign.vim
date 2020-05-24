# name-assign.vim

## Short introduction

This repository provides a Vim plugin to automate replacing expressions with
assigned variables in multiple programming language.

An animated Gif is worth a 1,000 words:

<img src="doc/name-assign.gif">


## Description

In many programming languages, a common editing operation is to move subexpressions
out of a nested expression into their own assigned names.

To illustrate, suppose we want to transform the following:

```c
call_func(some_code, some_complex_and_long_expression);
```

Into the following:

```c
let var = some_complex_and_long_expression;
...
call_func(some_code, var);
```

There can be any amount of lines between the top expression and the variable
assignment.

The plugin supports the following languages: Rust, C, C++, Go, VimScript,
JavaScript, Python, LISP, Scheme, Racket, Clojure.


## Usage instructions

First, note that the default kbd combination is <kbd>Alt</kbd> - <kbd>=</kbd>, and it is bound in visual mode.

Each usage has four steps:

* Mark the expression to replace with a visual selection.
* Hit the key combination, pick the name of the expression.
* Now in 'placement mode', move the assignment expression with <kbd>Up</kbd> or <kbd>Down</kbd>, or using <kbd>k</kbd> or <kbd>j</kbd>.
* End placing the assignment with <kbd>Esc</kbd> or <kbd>Return</kbd>.


### Overriding mappings

The trigger to activate can be set to a different key:

```viml
vmap <leader>b <Plug>NameAssign
```

It is also possible to override mappings done for the placement mode to
different keys, for example:

```viml
let g:name_assign_mode_maps = { "up" : ["n"],  "down" : ["N"] }
```

These mappings are temporary and buffer local, so they will not affect any
global mappings for the specified keys.

Here's the full list of actions:

* `up` : For moving the placement up
* `down` : For moving the placement down
* `settle` : For ending placement


## To Do

* Extend support to more languages.
* Allow to customize the content of the `@` register after the operation.
  Currently it will contain the entered name.
* Don't liter the undo history too much with the movement, or try to rely on
  [vim-schlepp](https://github.com/zirrostig/vim-schlepp) that probably does it
  better.
