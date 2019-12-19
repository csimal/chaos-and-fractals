using LinearAlgebra
using Statistics
using StatsBase

struct Box2
    # lower bounds
    xmin::Real
    ymin::Real
    # upper bounds
    xmax::Real
    ymax::Real
    # points in the box
    points
end

function subdivide_box(b::Box2)
    xhalf = (b.xmin+b.xmax)/2
    yhalf = (b.ymin+b.ymax)/2
    b1 = Box2(b.xmin, b.ymin, xhalf, yhalf, [])
    b2 = Box2(xhalf, b.ymin, b.xmax, yhalf, [])
    b3 = Box2(b.xmin, yhalf, xhalf, b.ymax, [])
    b4 = Box2(xhalf, yhalf, b.xmax, b.ymax, [])
    border_points = []
    for p in b.points
        if p[1] < xhalf
            if p[2] < yhalf
                push!(b1.points, p)
            elseif p[2] > yhalf
                push!(b3.points, p)
            else
                push!(border_points, p) # deal with it later
            end
        elseif p[1] > xhalf
            if p[2] < yhalf
                push!(b2.points, p)
            elseif p[2] > yhalf
                push!(b4.points, p)
            else
                push!(border_points, p)
            end
        else
            push!(border_points, p)
        end
    end
    # discard empty boxes
    boxes = filter(x->!isempty(x.points), [b1, b2, b3, b4])
    # add each point to the box whose mean is closest to it
    if !isempty(boxes)
        for p in border_points
            i = argmin(map(x->norm(mean(x)-p), map(x->x.points, boxes)))
            push!(boxes[i].points, p)
        end
    else
        # all points were on the border. Something went very wrong
        return []
    end

    return boxes
end

function box_counting_dimension_2d(points, maxiter=10, tol=0.001)
    if isempty(points)
        error("points must be non empty")
    end
    x = map(p->p[1], points)
    y = map(p->p[2], points)
    #ε = (abs(maximum(x)-minimum(x))+abs(maximum(y)-minimum(y)))/2
    ε = sqrt(abs(maximum(x)-minimum(x))*abs(maximum(y)-minimum(y))) # taking the geometric mean as the characteristic side length of the box
    N = Vector{Int}()
    d = Vector{Float64}()
    boxes = [Box2(minimum(x), minimum(y), maximum(x), maximum(y), points)]
    #old_boxes = []
    push!(N, length(boxes))
    push!(d, log(N[1])/(0*log(2)-log(ε)))
    i = 2
    while i <= maxiter && !isempty(boxes)
        #push!(old_boxes, boxes)
        tmp = map(subdivide_box, boxes)
        boxes = isempty(tmp) ? [] : foldl(append!, tmp)
        push!(N, length(boxes))
        push!(d, log(N[i])/((i-1)*log(2)-log(ε)))
        if abs(d[i]-d[i-1]) < tol
            break # exit if d seems to have converged. This is not entirely foolproof but it will avoid unnecessary iterations when `points` has too few elements
        end
        i += 1
    end
    #push!(old_boxes, boxes)
    return d, N, ε*2.0 .^ -(0:(i-2))#, old_boxes
end

# N-dimensional box
struct BoxN
    N::Integer
    mins::Vector{Real}
    maxs::Vector{Real}
    points::Vector{Vector{Real}}
end

function subdivide_box(b::BoxN)
    halves = (b.mins+b.maxs)/2
    boxes = Dict{BitVector,BoxN}()
    border_points = []
    for p in b.points
        if any(p .== halves)
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
    for p in border_points
        i = argmin(Dict([k=> norm(v-p) for (k,v) in centers]))
        push!(boxes[i].points, p)
    end
    return collect(values(boxes))
end

function box_counting_dimension(points, maxiter=10, tol=0.001)
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
    ε = geomean(abs.(maxs-mins))
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
            break # exit if d seems to have converged. This is not entirely foolproof but it will avoid unnecessary iterations when `points` has too few elements
        end
        i += 1
    end
    return d, N, ε*2.0 .^ -(0:(i-2))
end

function correlation_dimension(x, maxiter=10)
    if isempty(x)
        error("x must be non empty")
    end
    rmax = maximum(norm.(x)) # quick and dirty max radius
    N = length(x)
    for i in 1:N, j in i:N
        d = norm(x[i]-x[j])
        for k in 0:maxiter

        end
    end
end
