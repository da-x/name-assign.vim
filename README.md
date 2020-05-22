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

    call_func(some_code, some_complex_and_long_expression);

Into the following:

	let var = some_complex_and_long_expression;
	...
    call_func(some_code, var);

There can be any amount of lines between the top expression and the variable
assignment.

The plugin supports the following languages;

* Rust
* C/C++
* VimScript


## Usage instructions

First, note that the default kbd combination is <kbd>Alt</kbd> - <kbd>=</kbd>, and it is bound in visual mode.

Each usage has four steps:

* Mark the expression to replace with a visual selection.
* Hit the key combination, pick the name of the expression.
* Move the assignment line with <kbd>Up</kbd> or <kbd>Down</kbd>.
* End placing the assignment line with <kbd>Esc<kbd> or <kbd>Return</kbd>.


## TODO

* Allow customizing the defaults.
* Extend support to more languages.
