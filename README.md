# DACE.jl

**Work in progress**

Julia interface to [DACE](https://github.com/dacelib/dace).

## Example usage

Install dependencies:

```
(@v1.9) pkg> activate dacetest
(dacetest) pkg> add https://github.com/chrisdjscott/DACE_jll.jl.git
(dacetest) pkg> add https://github.com/chrisdjscott/DACE.jl.git
```

Run something:

```
julia> using DACE

julia> DACE.dacelibversion()
(2, 0, 1)
```
