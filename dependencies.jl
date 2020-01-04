#=
Install script for the required packages
=#
using Pkg

println("Installing necessary packages. This may take some time.")
Pkg.add("DifferentialEquations")
Pkg.add("DynamicalSystems")
Pkg.add("ChaosTools")
Pkg.add("Plots")
Pkg.add("Pyplot")
Pkg.add("PlotlyJS")
Pkg.add("Images")
Pkg.add("ImageMagick")
Pkg.add("StatsBase")
