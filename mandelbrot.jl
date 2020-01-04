using Plots
using Printf

"""
    untildivergence(f, x, maxiter=50)

Iterate `f` on `x` until its module is greater than 2 or `maxiter` iterations have been done.

Returns the number of iterations.
"""
function untildivergence(f, x, maxiter = 50)
    i = 0
    while abs(x) < 2 && (i += 1) <= maxiter
        x = f(x)
    end
    return i
end

"""
    julia_set_wh(f; kwargs)

Approximate the Julia set of `f` in a grid using the escape time algorithm.

The grid is defined by its bounds `xmin`, `xmax`, `ymin` and `ymax` as well as its width `w` and height `h` in pixels. The optional parameter `maxiter` is passed on to `untildivergence`.
"""
function julia_set_wh(f; xmin::Real=-2, xmax::Real=2, ymin::Real=-2, ymax::Real=2, w::Int=1000, h::Int=1000, maxiter::Int=50)
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

"""
    julia_set(f, cellsize; kwargs)

Approximate the Julia of `f` set in a grid of cells of length `cellsize`.

The grid is defined by the same parameters as in `julia_set_wh`, except its width and height in pixels are computed with `cellsize`.
"""
function julia_set(f, cellsize::Real; xmin=-2, xmax=2, ymin=-2, ymax=2, maxiter=50)
    w = Integer(round(abs(xmax-xmin)/cellsize))
    h = Integer(round(abs(ymax-ymin)/cellsize))
    return julia_set_wh(f, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, w=w, h=h, maxiter=maxiter)
end

"""
    mandelbrot_set_wh(f; kwargs)

Approximate the Mandelbrot set of `f` in a grid using the escape time algorithm.

The grid is defined by its bounds `xmin`, `xmax`, `ymin` and `ymax` as well as its width `w` and height `h` in pixels. The optional parameter `maxiter` is passed on to `untildivergence`.
"""
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

"""
    mandelbrot_set(f, cellsize; kwargs)

Approximate the Mandelbrot of `f` set in a grid of cells of length `cellsize`.

The grid is defined by the same parameters as in `julia_set_wh`, except its width and height in pixels are computed with `cellsize`.
"""
function mandelbrot_set(f, cellsize; xmin=-2, xmax=2, ymin=-2, ymax=2, maxiter=50)
    w = Integer(round(abs(xmax-xmin)/cellsize))
    h = Integer(round(abs(ymax-ymin)/cellsize))
    return mandelbrot_set_wh(f, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, w=w, h=h, maxiter=maxiter)
end

# the traditional julia/mandelbrot function
f(c) = z -> z^2 + c

img, xticks, xlabels, yticks, ylabels = mandelbrot_set(f, 0.00005, xmin=-2.01, xmax = -1.8, ymin = -0.1, ymax = 0.1)

img, xticks, xlabels, yticks, ylabels = julia_set(f(im), 0.0005, xmin=-2, xmax=2, ymin=-2,ymax=2)


heatmap(img,
        xticks = (xticks, xlabels),
        yticks = (yticks, ylabels),
        aspect_ratio=:equal
        )

# alternative, for better looking images
using Images, Colors
g = Gray.(img/51)

g = Gray.(.!(img .>= 50))

mset = img .>= 50

#save("julia_minus2.png", g)

include("FractalDimensions.jl")

B = boundary(mset)
Gray.(B)
points = array_to_points(B)

d, N, ε = box_counting_dimension(points, 10)

C, r = correlation_dimension(points)

loglog_regression(C,r)
