using DACE
using Test

@testset "DACE tests" begin

    @testset "Common tests" begin
        include("common_tests.jl")
    end
    
    @testset "DA tests" begin
        include("DA_tests.jl")
    end

    @testset "Validation tests" begin
        include("validation_3.jl")
    end
end
