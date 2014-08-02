# SaveREPL

A package to save previous inputs into the Julia REPL as scripts.

[![Build Status](https://travis-ci.org/sjkelly/SaveREPL.jl.svg?branch=master)](https://travis-ci.org/sjkelly/SaveREPL.jl)

## Use
```
julia> a = 1
1

julia> b = 2
2

julia> a + b
3

julia> p = "poop"
"poop"

julia> "skip this"
"skip this"

julia> h = "hello"
"hello"

julia> using SaveREPL

julia> saveREPL("script.jl")
	Which lines would you like to save?
	Lines: 2, 4:7
```

This will produce a script named "script.jl" with the following contents...

```
a = 1
b = 2
a + b
p = "poop"
h = "hello"
```

Lines are numbered in reverse-cronological order. In our example, line 1 would be `julia> using SaveREPL`. Line 7 would be `julia> a = 1`.

