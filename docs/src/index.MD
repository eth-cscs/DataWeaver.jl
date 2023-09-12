# [DataWeaver.jl] [![Star on GitHub](https://img.shields.io/github/stars/eth-cscs/DataWeaver.jl.svg)](https://github.com/eth-cscs/DataWeaver.jl/stargazers)
The package `DataWeaver` provides functionality that significantly simplifies the usage of [ADIOS2.jl].
More specifically, the package is targeted at domain scientists who want to take advantage of the
adaptable input/output system without having to care about the detailed API and cumbersome setup.

Our package has been designed to be as intuitive as possible and the main priority was ease of use.
Its main functionality relies on, essentially, just four functions that perform the initialization,
read/write setup and the actual reading/writing of data.

Browse through the documentation to learn more on how to get started quickly. In the examples section, you will
find minimal setups that illustrate the basic usage (which ought to suffice for the vast majority of cases).
In case you wish to delve into the details, we invite you to consult the API, as well as the original [ADIOS2.jl] documentation. The latter option is particularly suitable for advanced and curious users, who want to juxtapose the original [ADIOS2.jl] structure against our implementation.

## Dependencies
`DataWeaver` relies on [ADIOS2.jl].

## Contributors
The principal contributors to [DataWeaver.jl] are (ordered by the significance of the relative contributions):
- Maja Gwozdz, ([@mkg33](https://github.com/mkg33)), ETH Zurich
- Dr. Samuel Omlin ([@omlins](https://github.com/omlins)), CSCS - Swiss National Supercomputing Centre, ETH Zurich
