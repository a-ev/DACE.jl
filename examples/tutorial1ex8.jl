using DACE

DACE.init(1, 2)

function somb(x::Vector{DACE.DA})::DACE.DA
    return sin(sqrt(x[1]*x[1] + x[2]*x[2])) / sqrt(x[1]*x[1] + x[2]*x[2])
end

println("Initialize x as two-dim DA vector around (2,3)")

x = Vector{DACE.DA}(undef, 2)
x[1] = 2.0 + DACE.DA(1, 1.0)
x[2] = 3.0 + DACE.DA(2, 1.0)
println("x")
println(x)

z = somb(x)
println("Sombrero function")
println(z)

grad_z = DACE.gradient(z)
println("Gradient of sombrero function")
println(grad_z)
