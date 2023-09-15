"""
Module DataWeaver
"""

module DataWeaver

export init_data_weaver, write_setup, write, read_setup, reading, read, finalize_data_weaver,
       inspect_variables

let
    global init_data_weaver, write_setup, write, read_setup, reading, reading_now, read,
    finalize_data_weaver, adios, engine, vars, init_state, nprocessed

    include("rw.jl")
    include("utils.jl")
    include("visualize.jl")

end

end
