using Plots
using PyCall
using DifferentialEquations
using Statistics
using Base.Iterators


function rossler(du,u,p,t)
    x, y, z = u
    a, b, c = p
    du[1] = -y -z
    du[2] = x + a*y
    du[3] = b + z*(x-c)
end

p = [0.1,0.1,18]
u0 = [5., 5., 1.]
tspan = (0.0,1000.0)

prob = ODEProblem(rossler, u0, tspan, p)
tmp = solve(prob, abstol=1e-9)
prob = ODEProblem(rossler, tmp.u[end], (0.0,5000.0), p)
sol = solve(prob, abstol=1e-9)

pyplot()
pygui(false)
plot(sol,vars=(1,2,3), lw=0.1, legend=false)
savefig("rossler_c13.pdf")

function local_maxima(x::Vector{T}) where T<:Real
    y = []
    for i in 2:length(x)-1
        if x[i-1] < x[i] && x[i] > x[i+1]
            push!(y, x[i])
        end
    end
    return y
end

z = map(v->v[3], sol.u)
zmax = local_maxima(z)

pygui(false)
scatter(
    [zmax[i] for i in 1:(length(zmax)-1)],
    [zmax[i] for i in 2:length(zmax)],
    markersize=1,
    markerstrokealpha=0.0,
    markercolor = :black,
    legend=false,
    xlabel = "z[k]",
    ylabel = "z[k+1]"
    )


include("FractalDimensions.jl")
d, N, ε = box_counting_dimension(sol.u, 8)
loglog_regression(N,ε)

plot(-log.(ε), log.(N), xlabel="-ln ε", ylabel="ln N", marker=:d, legend=false)

C, r = correlation_dimension(sol.u, 15)
loglog_regression(C,r)

plot(log.(r), log.(C), xlabel="ln r", ylabel="ln C", marker=:d, legend=false)
savefig("cordim_rossler.pdf")


using DynamicalSystems
using ChaosTools
# almost feels like cheating
r = Systems.roessler(a=0.1,b=0.1,c=18)
lyapunov(r,1000.0)
λ = lyapunovs(r,1000.0)
kaplanyorke_dim(λ) # Lyapunov dimension


crange = LinRange(1,18,1000)
n = 5000
Ttr = 2000
# bifurcation diagram of the Poincaré map of the z coordinate on the plane y=0
diagram = produce_orbitdiagram(r, (2,0.0), 3, 3, crange; n=n, Ttr=Ttr)

L = length(crange)
x = []
y = []
for j in 1:L, z in diagram[j]
    push!(x,crange[j])
    push!(y,z)
end

plotlyjs()
scatter(
    x,
    y,
    markersize=0.5,
    markerstrokealpha=0.0,
    markercolor = :black,
    legend=false,
    grid = false,
    xlabel = "c",
    ylabel = "z"
    )

savefig("rossler_bifurcation.pdf")
