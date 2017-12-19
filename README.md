# assign-named.vim

This repository provides a Vim plugin to automate replacing expressions with
assigned variables in any programming language.

-

Common in many programming languages, a common editing operation is to move
subexpressions out of a nested expression into their own assigned names.

To illustrate, suppose we have want to transform the following:

    call_func(some_code, some_complex_and_long_expression);

Into the following:

	let var = some_complex_and_long_expression;
	...
    call_func(some_code, var);

There can be any amount of lines between the top expression and the variable
assignment.

We could do those edits manually, or we can use the `Alt =` binding with the
assign-named plugin.

	let var<Alt = here;
	...
    call_func(some_code, _visually_mark_the_long_expression_<Alt= here too>);

Here's an animated gif:

__TODO__

