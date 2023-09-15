using ADIOS2
using LinearAlgebra
using DataWeaver

init_data_weaver(filename = "adios2.xml", serial = true)     # specify the configuration file
read_setup("diffusion2D.bp")
inquire_all_variables(io)                                    # optional line - in case you want to inspect the variables
read("temperature")                                          # the specific variable we want to read
finalize_data_weaver()
