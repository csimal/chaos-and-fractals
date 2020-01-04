# This is an introductory julia script to help get new users quickly familiar with the basics
# It is recommended that you use JuliaPro, as it makes interacting with julia much easier

# If you are using JuliaPro, you can execute a line or block of code with Shift+Enter. Otherwise you can just use Julia in the console and copy-paste code to execute it
x = 0.0:0.01:1.0
# variable names can be unicode characters. Special characters like greek letters can be entered by typing them as in LaTeX, then hitting tab.
# for example \alpha -> α
μ = 4
# Functions are first class objects. You can assign them to variables and pass them to functions. In addition you can create anonymous functions using lambda expressions.
T = x -> μ*x*(1-x)

# Calling a function with a '.' at the end of its name applies it to every element of its input, usually an array. This is similar to Matlab
y = T.(x)

# Julia has many community packages that can be installed from the command line.
# Packages are loaded with the following syntax
using Plots
# The package Plots adds high level plotting functions
plot(x,y)
# When we want to plot a function, we can also pass it as an argument, along with the values we want to evaluate
plot(T,x, xlabel="x", ylabel="T(x)")

# Finally, variables all have a type, for instance Int64 or Float64. Julia uses type to optimize  code, especially functions
typeof(T(1))
typeof(T(0.5))
typeof(T(1//2))
# There are abstract types that encompass many concrete types, for example Real is the abstract type for real numbers, which encompasses Int64, Float64, etc. When declaring functions arguments with an abstract type, that function will work on any instance of that type.
function tent(x::Real, a::Real)
    if x <= 0.5
        return a*x
    else
        return a*(1-x)
    end
end

tent(1,3)
tent(0.5,3)
tent(1,3.1)
