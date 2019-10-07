using Plots
# define the Lorenz attractor
mutable struct Rossler
    dt; a; b; c; x; y; z
end

function step!(r::Rossler)
    dx = -(r.y + r.z)       ; r.x += r.dt * dx
    dy = r.x + r.a*r.y      ; r.y += r.dt * dy
    dz = r.b + r.z*(r.x-r.c); r.z += r.dt * dz
end

attractor = Rossler((dt = 0.02, a=0.2, b=0.2, c=5.7, x = 5., y = 5., z = 1.)...)


# initialize a 3D plot with 1 empty series
plt = plot3d(1, xlim=(-10,15), ylim=(-30,10), zlim=(0,30),
                title = "Rössler Attractor", marker = 2)

# build an animated gif by pushing new points to the plot, saving every 10th frame
@gif for i=1:5000
    step!(attractor)
    push!(plt, attractor.x, attractor.y, attractor.z)
end every 10
