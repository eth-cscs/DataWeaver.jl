push!(LOAD_PATH, "../src")

import DataWeaver # Precompile it.

excludedfiles = [ "test_excluded.jl"];

function runtests()
    exename   = Base.julia_cmd()
    testdir   = pwd()
    istest(f) = endswith(f, ".jl") && startswith(f, "test_")
    testfiles = sort(filter(istest, readdir(testdir)))

    nfail = 0
    printstyled("Testing package DataWeaver.jl\n"; bold=true, color=:white)
    for f in testfiles
        println("")
        if f ∈ excludedfiles
            println("Test Skip:")
            println("$f")
            continue
        end
        try
            run(`$exename -O3 --startup-file=no $(joinpath(testdir, f))`)
        catch ex
            nfail += 1
        end
    end
    return nfail
end
exit(runtests())
