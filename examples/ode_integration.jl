"""
This tutorials shows how to perform the numerical 
integration of an ordinary differential equation (ODE) 
using DA objects as the state components' type.

It propagates the differential equations for 
the Keplerian motion in Cartesian parameters.
"""

using OrdinaryDiffEq
using DACE

# initial parameters defining a circular orbit propagated for 1 revolution
μ = 1.0
ts = 0.0
tf = 2π
xs = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0]

# equations of motion
function kepler_ode!(du, u, p, t)
    du[1:3] .= u[4:6]
    du[4:6] .= -u[1:3] * μ ./ sum(u[1:3].^2)^(3/2)
end

# nominal solution
prob = ODEProblem(kepler_ode!, xs, [ts, tf])
sol = solve(prob, DP8(), abstol=1e-12, reltol=1e-12)

# DACE initialization for computations at second order
DACE.init(2,6)

# initial conditions as DA vector
dx_dace = [DA(i,1.0) for i in 1:6]
xs_dace = xs .+ dx_dace

# polynomial expansion of the dynamics flow
sol_dace = solve(remake(prob, u0=xs_dace), DP8(), abstol=1e-12, reltol=1e-12)

# verify that the time steps chosen by the integrator coincide
t_dace = sol_dace.t

println("Time steps coincide: " * string(all(t_dace .≈ sol.t)))

# verify the (nominal) final state
xf_dace = sol_dace.u[end]
xf_cons = DACE.cons.(xf_dace)

println("Max abs error on final state: " * string(maximum(abs.(xf_cons - sol.u[end]))))

# extract and print the state transition matrix (STM)
function dace_jacobian(v::Vector{<:DA})
    jac = Matrix{Float64}(undef, length(v), DACE.getMaxVariables())
    for i in 1:length(v)
        for j in 1:DACE.getMaxVariables()
            jac[i,j] = DACE.cons(DACE.deriv(v[i],j))
        end
    end
    return jac
end;

stm_dace = dace_jacobian(xf_dace)
println("State transition matrix:")
display(stm_dace)
