# name-assign.vim

## Short introduction

This repository provides a Vim plugin to automate replacing expressions with
assigned variables in any programming language.

An animated gif is worth a 1,000 words:

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

## Usage instructions

First, note that the default kbd combination is <kbd>Alt</kbd> - <kbd>=</kbd>, and it is bound in normal mode, visual mode and insert mode.

Each usage has three steps:

* Put the key combination at the end of a new variable declaration, right after the name.
* Perform a visual mark of the expression to replace.
* Hit the key combination again - see the expression is being replaced by the name and the name is added with the assigned expression.

## Limitations

* Expressions spanning multiple lines are not currently supported.
* The defaults are not as flexible as they could be. If you want different defaults, look at the last part part of the plugin's source.
