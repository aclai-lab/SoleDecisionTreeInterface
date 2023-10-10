# using Revise
using SoleModels
using SoleLogics
using Test
using Random
using ThreadSafeDicts

function run_tests(list)
    println("\n" * ("#"^50))
    for test in list
        println("TEST: $test")
        include(test)
    end
end

println("Julia version: ", VERSION)

test_suites = [
    ("Pluto Demo", ["$(dirname(dirname(pathof(SoleModels))))/pluto-demo.jl", ]),
    ("Logisets", [
        "logisets/logisets.jl",
        # "logisets/memosets.jl", # TODO bring back
        "logisets/cube2logiset.jl",
        # "logisets/dataframe2logiset.jl",
        "logisets/multilogisets.jl",
        "logisets/MLJ.jl",
    ]),
    ("Models", ["base.jl", ]),
    ("Miscellaneous", ["misc.jl", "minify.jl"]),
    ("Parse", ["parse.jl", ]),
]

@testset "SoleModels.jl" begin
    for ts in eachindex(test_suites)
        name = test_suites[ts][1]
        list = test_suites[ts][2]
        let
            @testset "$name" begin
                run_tests(list)
            end
        end
    end
    println()
end
