using Plots
using PyCall
using DifferentialEquations


p = [0.2,0.2,5.7]


function rossler(du,u,p,t)
    x, y, z = u
    a, b, c = p
    du[1] = -y -z
    du[2] = x + a*y
    du[3] = b + z*(x-c)
end

u0 = [5., 5., 1.]
tspan = (0.0,100.0)

prob = ODEProblem(rossler, u0, tspan, p)
sol = solve(prob)

#plotlyjs()
pyplot()
pygui(true)
plot(sol,vars=(1,2,3))
