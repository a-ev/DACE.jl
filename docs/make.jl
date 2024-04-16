push!(LOAD_PATH, joinpath(@__DIR__, ".."))

using Documenter
using Literate
using DACE

# generate examples, based on https://github.com/CliMA/Oceananigans.jl/blob/1c2a6f8752b6425bf30d856f8ba0aa681c0ab818/docs/make.jl

const EXAMPLES_DIR = joinpath(@__DIR__, "..", "examples")
const OUTPUT_DIR = joinpath(@__DIR__, "src", "generated")

example_scripts = [
    "sine.jl",
    "polynomial_inversion.jl",
]

println("Building examples...")
for example in example_scripts
    println("Building: $example")
    example_filepath = joinpath(EXAMPLES_DIR, example)

    Literate.markdown(example_filepath, OUTPUT_DIR;
                      flavor = Literate.DocumenterFlavor(), execute = true)
end
println("Finished building examples")

# organise pages

example_pages = [
    "Sine function" => "generated/sine.md",
    "Polynomial inversion" => "generated/polynomial_inversion.md",
]

tutorial_pages = [
    "Setting up your development environment" => "tutorials/setting-up-your-development-environment.md",
]

pages = [
    "Home" => "index.md",
    "Developer Guide" => "developing.md",
    "Tutorials" => tutorial_pages,
    "Examples" => example_pages,
]

# build and deploy docs

format = Documenter.HTML(
    prettyurls = get(ENV, "CI", nothing) == "true",
)

makedocs(
    sitename = "DACE.jl",
    format = format,
    pages = pages,
#    modules = [DACE],
)

deploydocs(
    repo = "github.com/a-ev/DACE.jl.git",
)
