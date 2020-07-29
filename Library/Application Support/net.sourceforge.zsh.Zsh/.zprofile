##############
# Setting PATH
##############
# So macOS has this thing called path_helper that modifies PATH *after*
# .zshenv is sourced, which is fine except I would like the following to be
# at the front of PATH. I suppose I have several options: I could add the
# following to .zshrc, but .zshrc is only sourced on interactive shells
# (is that a problem for python3 and llvm?); I could also create aliases
# so that "python3" refers to, e.g. /usr/local/opt/python@3.8/bin/python3
# instead of /usr/local/bin/python3, but aliases don't feel like a robust
# solution to me. Oh well. I decided to see if modifying PATH here in .zpofile
# solves my problem.
##############

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
# And also use a version of LLVM that supports LeakSanitizer
# export PATH="/usr/local/opt/python@3.8/bin:${PATH}"
path=(/usr/local/opt/python@3.8/bin /usr/local/opt/llvm/bin $path)
# export PATH="/usr/local/opt/llvm/bin:$PATH"
