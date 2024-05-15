using DACE
using Test

include("utils.jl")

@testset verbose = true "DACE tests" begin
    @testset verbose = true "Tutorials" begin
        include("tutorial_tests.jl")
    end

    @testset verbose = true "Validation tests" begin
        include("validation_1.jl")
        include("validation_2.jl")
    end

    @testset verbose = true "Operators" begin
        include("comparison_operators.jl")
    end
end
