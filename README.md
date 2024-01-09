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

Run an example:

```
$ julia --project examples/example1.jl
x
     I  COEFFICIENT              ORDER EXPONENTS
     1    1.0000000000000000e+00   1   1
------------------------------------------------
y = sin(x)
     I  COEFFICIENT              ORDER EXPONENTS
     1    1.0000000000000000e+00   1   1
     2   -1.6666666666666666e-01   3   3
     3    8.3333333333333332e-03   5   5
     4   -1.9841269841269841e-04   7   7
     5    2.7557319223985893e-06   9   9
     6   -2.5052108385441720e-08  11  11
     7    1.6059043836821616e-10  13  13
     8   -7.6471637318198174e-13  15  15
     9    2.8114572543455210e-15  17  17
    10   -8.2206352466243310e-18  19  19
------------------------------------------------
y(1.0)   = 0.8414709848078965
sin(1.0) = 0.8414709848078965
```

More examples of how to use *DACE.jl* can be found in the tests, for example [validation_2.jl](tests/validation_2.jl).
