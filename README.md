# DACE.jl

**Work in progress**

Julia interface to [DACE](https://github.com/dacelib/dace).

## Example usage

Install dependencies:

```
$ julia --project
(DACE) pkg> add https://github.com/chrisdjscott/DACE_jll.jl.git
(DACE) pkg> add https://github.com/chrisdjscott/DACE.jl.git
```

Run something:

```
julia> using DACE

julia> DACE.dacegetversion()
(2, 0, 1)
```

Run an example:

```
$ julia --project examples/example1.jl
x
     I  COEFFICIENT              ORDER EXPONENTS
     1    1.0000000000000000e+00   0   0
------------------------------------------------
y = sin(x)
     I  COEFFICIENT              ORDER EXPONENTS
     1    8.4147098480789650e-01   0   0
------------------------------------------------
```
