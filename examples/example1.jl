using DACE

# initialise DACE for 20th-order computations in 1 variable
DACE.init(20, 1)

# initialise x as DA
x = DACE.DA(1)

# compute y = sin(x)
y = sin(x)

# print x and y to screen
println("x")
print(DACE.tostring(x))
println("y = sin(x)")
print(DACE.tostring(y))