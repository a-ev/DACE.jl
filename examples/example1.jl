using DACE

# initialise DACE for 20th-order computations in 1 variable
DACE.init(20, 1)

# initialise x as DA
x = DACE.DA(1)

# y = sin(x)
y = sin(x)

# print x and y to screen
println("x")
print(x)
println("y = sin(x)")
print(y)

# evaluate y at 1.0
println("y(1.0) = $(DACE.evalScalar(y, 1.0))")
