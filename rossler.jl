using Plots
using PyCall
using DifferentialEquations
using Statistics
using Base.Iterators


p = [0.1,0.1,6.0]

function rossler(du,u,p,t)
    x, y, z = u
    a, b, c = p
    du[1] = -y -z
    du[2] = x + a*y
    du[3] = b + z*(x-c)
end

u0 = [5., 5., 1.]
tspan = (0.0,5000.0)

prob = ODEProblem(rossler, u0, tspan, p)
sol = solve(prob, abstol=1e-9)

pyplot()
pygui(true)
plot(sol,vars=(1,2,3), line=1)

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

plot(zmax)

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
diagram = produce_orbitdiagram(r, (2,0.0), 3, 3, crange; n=n, Ttr=Ttr)

L = length(crange)
x = []
y = []
for j in 1:L, z in diagram[j]
    push!(x,crange[j])
    push!(y,z)
end

gr()
scatter(
    x,
    y,
    markersize=0.1,
    markerstrokealpha=0.0,
    markercolor = :black,
    legend=false,
    xlabel = "c",
    ylabel = "z"
    )
