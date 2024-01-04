using DACE
using Test

@testset verbose = true "DACE tests" begin
    @testset verbose = true "Tutorials" begin
        include("tutorial_tests.jl")
    end

    @testset verbose = true "Validation tests" begin
        include("validation_2.jl")
        include("validation_3.jl")
    end
end
