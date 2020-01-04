using LinearAlgebra
using Statistics
using StatsBase


# N-dimensional box
struct BoxN
    N::Integer # dimension of the box
    mins::Vector{Float64} # vector of lower bounds on each dimension
    maxs::Vector{Float64} # vector of upper bounds
    points::Vector{Vector{Float64}} # points inside the box
end

"""
    subdivide_box(b::BoxN)

Subdivide an N-dimensional box `b` into 2^N subboxes with half the side lengths of `b`.

The points in `b` are assigned to their respective subboxes. Any point on the border of multiple boxes is put into the box whose mean point is closest to it. Returns an array of non empty boxes.
"""
function subdivide_box(b::BoxN)
    halves = (b.mins+b.maxs)/2
    boxes = Dict{BitVector,BoxN}()
    border_points = []
    for p in b.points
        if any(p .== halves) # does p lie on the border of multiple boxes?
            push!(border_points, p)
        else
            key = p .> halves
            if !haskey(boxes, key)
                mins = (.!key) .* b.mins + key .* halves
                maxs = (.!key) .* halves + key .* b.maxs
                boxes[key] = BoxN(b.N, mins, maxs, [p])
            else
                push!(boxes[key].points, p)
            end
        end
    end
    if isempty(boxes)
        return []
    end
    centers = [(k, mean(v.points)) for (k,v) in boxes]
    # assign each border point to the box whose center is closest to it
    for p in border_points
        i = argmin(Dict([k=> norm(v-p) for (k,v) in centers]))
        push!(boxes[i].points, p)
    end
    return collect(values(boxes))
end

"""
    box_counting_dimension(points, maxiter=10, tol=0.001)

Approximate the box counting dimension of `points` defined by
`` d = \\lim_{ε\\longrightarrow0}\\frac{\\ln N_ε(E)}{-\\ln ε}. ``

 This is done by taking the smallest box containing all points and subdividing it up to `maxiter` times or until d seems to have converged (with tolerance `tol`).
 Returns vectors `d`, `N` and `ε`, containing respectively the iterates of d, the number of boxes N, and the box length ε.
"""
function box_counting_dimension(points::Vector{Vector{T}}, maxiter=10, tol=0.001) where T <: Real
    if isempty(points)
        error("points must be non empty")
    end
    n = length(points[1])
    mins = Vector(undef, n)
    maxs = Vector(undef, n)
    for i in 1:n
        tmp = [points[j][i] for j in 1:length(points)]
        mins[i] = minimum(tmp)
        maxs[i] = maximum(tmp)
    end
    boxes = [BoxN(n, mins, maxs, points)]
    ε = geomean(abs.(maxs-mins)) # use geomtric mean for side length
    N = [1]
    d = Vector{Float64}()
    push!(d, log(N[1])/(0*log(2)-log(ε)))
    i = 2
    while i <= maxiter && !isempty(boxes)
        tmp = map(subdivide_box, boxes)
        boxes = isempty(tmp) ? [] : foldl(append!, tmp)
        push!(N, length(boxes))
        push!(d, log(N[i])/((i-1)*log(2)-log(ε)))
        if abs(d[i]-d[i-1]) < tol
            break # exit if d seems to have converged. This is not entirely foolproof but it will avoid unnecessary iterations when `points` has too few elements. Set tol=0.0 to disable
        end
        i += 1
    end
    return d, N, ε*2.0 .^ -(0:(length(N)-1))
end

function box_counting_dimension(points::Vector{T}, maxiter=10, tol=0.001) where T<:Real
    return box_counting_dimension(map(x->[x], points), maxiter, tol)
end

"""
    box_counting_dimension(A, maxiter=10, tol=0.001)

Approximate the box counting dimension for a 2D array of bools.

This is meant for use with images and 2D arrays by selecting which pixels you want with a predicate.
"""
function box_counting_dimension(A::BitArray{2}, maxiter=10, tol=0.001)
    return box_counting_dimension(array_to_points(A), maxiter, tol)
end

"""
    array_to_points(A)

Convert a 2D Array of bools to a list of 2D points corresponding to indices where `A` is `true`.
"""
function array_to_points(A::BitArray{2})
    (m,n) = size(A)
    points::Vector{Vector{Float64}} = []
    for j in 1:n, i in 1:m
        if A[i,j]
            push!(points, [(i-0.5)/m, (j-0.5)/n])
        end
    end
    return points
end

"""
    boundary(A)

Compute the boundary a 2D region.

The region is represented by a 2D BitArray where entries equal to `true` denote points in the region.
"""
function boundary(A::BitArray{2})
    (m,n) = size(A)
    B = falses(m,n)
    for j in 1:n, i in 1:m
        sum = 0
        if i > 1 sum += A[i-1,j]; end
        if i < m sum += A[i+1,j]; end
        if j > 1 sum += A[i,j-1]; end
        if j < n sum += A[i,j+1]; end
        if sum < 4 && sum > 1
            B[i,j] = true
        end
    end
    return B
end

"""
    correlation_dimension(x, maxiter=10)

Approximate the correlation dimension of `x` using `maxiter` iterations.

Returns vectors `C` and `r` containing the iterates of the correlation function ``C(r)`` and the radii ``r``.
"""
function correlation_dimension(x::Vector{Vector{T}}, maxiter::Int=10) where T <: Real
    if isempty(x)
        error("x must be non empty")
    end
    r = maximum(norm.(x)) # quick and dirty max radius
    N = length(x)
    Cnums = zeros(Int, maxiter)
    C = zeros(maxiter)
    for i in 1:N-1, j in i+1:N
        d = norm(x[i]-x[j])
        for k in 1:maxiter
            if d > r*2.0^(-k)
                break
            else
                Cnums[k] += 1
            end
        end
    end
    C = float(Cnums)/((N*(N-1))/2)
    return C, r * 2.0 .^ -(1:maxiter)
end

"""
    loglog_regression(y,x)

Compute the OLS regression of `log.(y)` by `log.(x)`.

This only returns the coefficients, so you may want to use the `GLM` package for more information.
"""
function loglog_regression(y::Vector,x::Vector)
    X = ones(length(x),2)
    X[:,1] = log.(x)
    return X\log.(y)
end
