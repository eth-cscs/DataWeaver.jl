"""
Module DataWeaver
"""

module DataWeaver

export adios2_init, write_setup, write, read_setup, reading, read, finalize_adios,
       inspect_variables

let
    global adios2_init, write_setup, write, read_setup, reading, reading_now, read,
    finalize_adios, adios, engine, vars, init_state, nprocessed

    include("rw.jl")
    include("utils.jl")
    include("visualize.jl")

end

end
