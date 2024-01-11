@testset "Tutorial 1 Example 6" begin
    function ErrFunc(x::DA)::DA
        my_pi = 4.0 * atan(1.0)
        z = 1.0 / sqrt(2.0 * my_pi) * exp(-x * x / 2)
        return z
    end

    # initialize DACE for 24th-order computations in 1 variable
    DACE.init(24, 1)

    x = DA(1)

    # compute Taylor expansion of the erf
    y = ErrFunc(x)

    # compute the Taylor expansion of the indefinite integral of erf
    Inty = DACE.integ(y, 1)

    # compute int_{-1}^{+1} (erf)
    value = DACE.evalScalar(Inty, 1.0) - DACE.evalScalar(Inty, -1.0)

    @test isapprox(value, 0.682689492137, atol=1e-8, rtol=1e-5)
end
