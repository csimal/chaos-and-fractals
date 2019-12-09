using Plots
using Printf
#using PlotlyJS

function untildivergence(f, x, maxiter = 50)
    i = 0
    while abs(x) < 2 && (i += 1) <= maxiter
        x = f(x)
    end
    return i
end

function julia_set_wh(f; xmin::Real=-2, xmax::Real=2, ymin::Real=-2, ymax::Real=2, w::Integer=1000, h::Integer=1000, maxiter::Integer=50)
    img = Array{Int,2}(undef, h, w)
    x = LinRange(xmin, xmax, w)
    y = LinRange(ymin, ymax, h)
    # creating labels for use with `heatmap`
    xticks = LinRange(1,w,11)
    yticks = LinRange(1,h,11)
    xlabels = map(z->@sprintf("%.2f",z), LinRange(xmin,xmax,11))
    ylabels = map(z->@sprintf("%.2f",z), LinRange(ymin,ymax,11))

    for i in 1:w, j in 1:h
        img[j,i] = untildivergence(f, x[i]+im*y[j], maxiter)
    end
    return img, xticks, xlabels, yticks, ylabels
end

function julia_set(f, cellsize::Real; xmin=-2, xmax=2, ymin=-2, ymax=2, maxiter=50)
    w = Integer(round(abs(xmax-xmin)/cellsize))
    h = Integer(round(abs(ymax-ymin)/cellsize))
    return julia_set_wh(f, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, w=w, h=h, maxiter=maxiter)
end

function mandelbrot_set_wh(f; xmin::Real=-2, xmax::Real=2, ymin::Real=-2, ymax::Real=2, w::Integer=1000, h::Integer=1000, maxiter::Integer=50)
    img = Array{Int,2}(undef, h, w)
    x = LinRange(xmin, xmax, w)
    y = LinRange(ymin, ymax, h)
    # creating labels for use with `heatmap`
    xticks = LinRange(1,w,11)
    yticks = LinRange(1,h,11)
    xlabels = map(z->@sprintf("%.2f",z), LinRange(xmin,xmax,11))
    ylabels = map(z->@sprintf("%.2f",z), LinRange(ymin,ymax,11))

    for i in 1:w, j in 1:h
        img[j,i] = untildivergence(f(x[i]+im*y[j]), 0, maxiter)
    end
    return img, xticks, xlabels, yticks, ylabels
end

function mandelbrot_set(f, cellsize; xmin=-2, xmax=2, ymin=-2, ymax=2, maxiter=50)
    w = Integer(round(abs(xmax-xmin)/cellsize))
    h = Integer(round(abs(ymax-ymin)/cellsize))
    return mandelbrot_set_wh(f, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, w=w, h=h, maxiter=maxiter)
end

f(c) = z -> z^2 + c

const w, h = 1000, 1000

img, xticks, xlabels, yticks, ylabels = mandelbrot_set(f, 0.001, xmax = 1, ymin = -1.5, ymax = 1.5)
#img, xticks, xlabels, yticks, ylabels = julia_set(f(-0.17+im*0.78), 0.0005, xmin=-1.4, xmax=1.4, ymin=-1.2,ymax=1.2)

#plotlyjs()
heatmap(img,
        xticks = (xticks, xlabels),
        yticks = (yticks, ylabels),
        aspect_ratio=:equal
        )

#= alternative, for better image aliasing
using Images, Colors
Gray.(img/50)
=#
