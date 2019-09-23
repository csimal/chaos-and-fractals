#using Plots
using PlotlyJS

function untildivergence(f::Function, x, maxiter = 30)
    i = 0
    while abs(x) < 2 && (i += 1) <= maxiter
        x = f(x)
    end
    return i
end

f(c) = z -> z^2 + c

const w, h = 1000, 1000
const zoom = 0.5
const moveX = 0
const moveY = 0

img = Array{Int,2}(undef,w,h)

for x in 1:w
    for y in 1:h
        c = Complex(
            (2*x - w) / (w * zoom) + moveX,
            (2*y - h) / (h * zoom) + moveY
        )
        img[x,y] = untildivergence(f(c),0)
    end
end

#plotlyjs()
PlotlyJS.plot(PlotlyJS.heatmap(z=img))
