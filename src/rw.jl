using ADIOS2
using Plots

    """
    Intialize ADIOS2. Supports several configuration options: MPI, serial,
    existing XML config file or a new file with specified parameters.
    """
    function init_data_weaver(; filename::AbstractString = "", engine_type = "",
                         serial = false, comm = nothing)

        use_mpi = !isnothing(comm)

        adios = nothing

        if isempty(filename)
            if serial
                global adios = adios_init_serial()
            elseif use_mpi
                filename = adios2_config(engine = engine_type)
                global adios = ADIOS2.adios_init_mpi(joinpath(pwd(), filename), comm)
            else serial_file
                filename = adios2_config(engine = engine_type)
                global adios = ADIOS2.adios_init_serial(joinpath(pwd(), filename))
            end
        else
            if use_mpi
                global adios = ADIOS2.adios_init_mpi(joinpath(pwd(), filename), comm)
            else
                global adios = ADIOS2.adios_init_serial(joinpath(pwd(), filename))
            end
        end

        global init_state = true          # mark the initialization step
        global vars = []                  # initialize the variable array (used later for reading and writing)
        global nprocessed = 0             # needed for the reading step
        global reading_now = false        # flag for the reading loop (to avoid race conditions)
    end

    """
    Initialize io in read mode and the corresponding engine for reading data.
    """
    function read_setup(bp_filename = "")

        global io = ADIOS2.declare_io(adios, "readerIO")
        bp_path = joinpath(pwd(), bp_filename)
        global engine = ADIOS2.open(io, bp_path, mode_read)    # Open the file/stream from the .bp file

    end

    """
    Initialize io in write mode and the corresponding engine for writing data.
    """
    function write_setup(variables ...; bp_filename = "")

        io = ADIOS2.declare_io(adios, "IO")

        for var_pair in variables
            var_id = define_variable(io, var_pair.first, eltype(var_pair.second))  # Define a new variable
            push!(vars, var_id)
        end

        bp_path = joinpath(pwd(), bp_filename)
        global engine = ADIOS2.open(io, bp_path, mode_write)   # Open the file/stream from the .bp file

    end

    """
    Perform the update using specified variables.
    """
    function write(update_var = nothing ...)

        for v in vars
            begin_step(engine)                                       # Begin ADIOS2 write step
            put!(engine, v, update_var)                              # Add update_var to variables for writing
            end_step(engine)                                         # End ADIOS2 write step (normally, also includes the actual writing of data)
        end

    end

    """
    Encodes the loop condition for the reading step.
    """

    function reading(; timeout = 100.0)

        if ADIOS2.begin_step(engine, step_mode_read, timeout) != step_status_end_of_stream
            global reading_now = true
            return true
        else
            global reading_now = false
            global nprocessed = 0
            return false
        end

    end

    """
    Reads the data sequentially. This function is particularly useful when called from a loop.
    """

    function read(var; verbose = true)

        var_id = inquire_variable(io, var)

        if nprocessed == 0
            nxy_global = shape(var_id)                                               # Extract meta data
            nxy        = count(var_id)                                               # ...
            var_type   = type(var_id)                                                # ...
            global V   = zeros(var_type, nxy)                                        # Preallocate memory for the variable using the meta data
        end

        get(engine, var_id, V)

        if reading_now                                                              # end the step automatically if loop detected
            end_step(engine)
            global nprocessed += 1
        end


        if verbose
            print("Variable: " * string(var))
            #print("Step: " * string(nprocessed))
            #print("Variable steps: " * string(steps(var_id)))
            #print("Current step: " * string(current_step(engine)))
        end

    end

    """
    Provide details about all avaiable variables listed in the ADIOS2 file.
    """

    function inspect_variables(filename::AbstractString = "")
        if !isempty(filename)
            var_info = adios_all_variable_names(filename)
            print(var_info)
        else
            print("error")
        end
    end

    """
    Close the ADIOS2 engine once all steps have been performed.
    """
    function finalize_data_weaver()

        if init_state == true
            close(engine)
        else
            print("Error. ADIOS2 hasn't been initialized.")
        end

    end

    """
    If the ADIOS2 config file is not provided, this function uses the XML
    template to create the file automatically with parameters provided by the
    user. Returns the XML path to the new file.
    """
    function adios2_config(engine_type = "")

        template_path = joinpath(pwd(), "adios2_template.xml")
        xml_path = joinpath(pwd(), "adios2_config.xml") # save location

        adios2_template = open(template_path, "r")

        adios2_xml = open(xml_path, "w")

        cp(template_path, xml_path, force = true)

        # temp file for replacing modified lines

        if cmp(engine_type, "SST") == 0
            for line in eachline(xml_path, keep = true)
                if occursin("ENGINE_TYPE", line)
                    line = "<engine type=\"SST\">"
                end
                write(adios2_xml, line)
            end
        elseif cmp(engine_type, "BP4") == 0
            for line in eachline(xml_path, keep = true)
                if occursin("ENGINE_TYPE", line)
                    line = "<engine type=\"BP4\">"
                end
                write(adios2_xml, line)
            end

        else
            println("Error")
        end

        close(adios2_template)
        close(adios2_xml)

        return xml_path
    end
