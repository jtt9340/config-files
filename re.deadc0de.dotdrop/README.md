# dotdrop
That is the program that manages these config files! dotdrop is able to dynamically
generate the contents of these files through the use of [Jinja templates][jinja], which
feature "filters", or functions you can pass template values through to transform them.
In some of my files, I wanted something similar to Vim's `shellescape` function, which
is convenently available in the Python standard library as `shlex.quote`. The singular
Python file in this directory exposes that function under the name `shellescape` to be
used in other templates.

[jinja]: https://jinja.palletsprojects.com/en/3.1.x/
