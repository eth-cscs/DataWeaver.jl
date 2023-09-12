# Usage
Have a look at the [Examples](@ref) and see the [API reference](@ref) for details on the usage of `DataWeaver`.


## Installation
`DataWeaver` can be installed directly with the [Julia package manager] from the [Julia REPL]:
```julia-repl
julia>]
  pkg> add DataWeaver
```

## Note
If you re-run a file that relies on [MPI.jl] (which is commonly used in conjunction with `DataWeaver`), you may have to restart `julia` before you can successfully run the file again. This behavior is sometimes occurs when working with [MPI.jl].
