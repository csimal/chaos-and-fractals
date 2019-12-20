include("FractalDimensions.jl")

S_0 = [[0.0,0.0], [1.0,0.0], [0.5,1.0]]
S_0 = [[0.0,0.0], [1.0,0.0], [0.5,2.0]]
S_0 = [[0.0,0.0], [1.0,0.0], [0.0,1.0]]


f1(x) = (S_0[1]+x)/2
f2(x) = (S_0[2]+x)/2
f3(x) = (S_0[3]+x)/2

# WARNING This will use up all of your memory and slow down your computer for k>10
function sierpinsky_endpoints(k)
        s::Vector{Vector{Float64}} = []
        s1 = S_0
        for i in 1:k
            s2 = setdiff([f1.(s1); f2.(s1); f3.(s1)], s1)
            append!(s, s1)
            s1 = s2
        end
    return s
end

s = sierpinsky_endpoints(10)

using Plots
x = [u[1] for u in s]
y = [u[2] for u in s]
scatter(x,y, markersize=1, markerstrokealpha=0.0, legend=false)

#d, N, ε = box_counting_dimension_2d(s, 10)

d, N, ε = box_counting_dimension(s, 10)

rectangle(xmin, xmax, ymin, ymax) = Shape([(xmin,ymin),(xmin,ymax),(xmax,ymax),(xmax,ymin)])

using Base.Iterators
for lb in take(boxes,5)
    for b in lb
        plot!(rectangle(b.xmin,b.xmax,b.ymin,b.ymax),opacity=0.20)
    end
end

plot!()

X = ones(9,2)
X[:,1] = -log.(ε[1:9])

X\log.(N[1:9])

log(3)/log(2)

plot(-log.(ε), log.(N))

C, r = correlation_dimension(s)

plot(log.(C), log.(r))

Y = ones(10,2)
Y[:,1] = log.(r)

Y\log.(C)
