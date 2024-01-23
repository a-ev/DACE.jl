push!(LOAD_PATH, joinpath(@__DIR__, ".."))

using Documenter, DACE

makedocs(
    sitename="DACE.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
    ),
)
