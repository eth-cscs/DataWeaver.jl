```@meta
CurrentModule = DataWeaver
```

# API reference

This is the official API reference of `DataWeaver`. Note that it can also be queried interactively from the [Julia REPL] using the [help mode](https://docs.julialang.org/en/v1/stdlib/REPL/#Help-mode):
```julia-repl
julia> using DataWeaver
julia>?
help?> DataWeaver
```


#### Documentation
```@autodocs
Modules = [DataWeaver]
Order   = [:type]
Filter = t -> typeof(t) !== CellArray
```


## Functions -- additional to standard `AbstractArray` functionality
#### Index
```@index
Order = [:function]
```
#### Documentation
```@autodocs
Modules = [DataWeaver]
Order   = [:function]
```
