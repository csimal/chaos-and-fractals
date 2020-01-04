# chaos-and-fractals

Various functions and code samples centered around Chaos and Fractals. This was made by C. Simal and J. Mohet as part of their 2019-2020 Master's Course *Chaos et Déterminisme* at Unamur.

## Installation
Most of the code is in [Julia](http://www.julialang.org). In order to run it, we recommend you use [JuliaPro](https://juliacomputing.com/products/juliapro.html) as it allows using Julia in a workflow similar to Matlab. Users coming from Matlab should check out [this page](https://docs.julialang.org/en/v1/manual/noteworthy-differences/) for a detailed list of the differences between both languages. Some code is in Octave/Matlab

Once you've installed Julia and downloaded the code, you will need to install several community packages. Thankfully, this can be done very easily by running `dependencies.jl`. If you want a quick introduction to the basics of Julia, we recommend you look at `introduction.jl` first.

The code was initially developed on Julia 1.2.0, but was tested without issues on Julia 1.3.0 (the latest Julia release at the time of writing)

## Overview of the project files
`dependencies.jl`: Installation script for community packages.

`introduction.jl`: Introductory script for users unfamiliar with Julia.

`FractalDimensions.jl`: Implementations of the box counting dimension and the correlation dimension, along with some companion functions.

`sierpinsky.jl`: Simple script that generates an approximation of the Sierpinsky triangle and tests the fractal dimension functions from `FractalDimensions.jl` on it.

`mandelbrot.jl`: Script implementing functions for generating arbitrary Julia and Mandelbrot sets, and plot them as images.

`bifurcationdiagramlogistic.m`: Bifurcation diagram of the logistic map in Octave/Matlab

`logisticmap.m`: Orbits of the logistic map in Octave/Matlab

`lyapunovexp.m`: Computation of the Lyapunov exponent of orbits of the logistic map. (In Octave/Matlab)

`rossler.jl`: Script for integrating the rössler equations and do various operations on the resulting solution.
