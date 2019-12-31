include("FractalDimensions.jl")

S_0 = [[0.0,0.0], [1.0,0.0], [0.5,1.0]]
S_0 = [[0.0,0.0], [1.0,0.0], [0.5,2.0]]
S_0 = [[0.0,0.0], [1.0,0.0], [0.0,1.0]]


f1(x) = (S_0[1]+x)/2
f2(x) = (S_0[2]+x)/2
f3(x) = (S_0[3]+x)/2

# WARNING This will use up your memory and slow down your computer for k>10
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

plotlyjs()
scatter(x,y, markersize=1, markerstrokealpha=0.0, legend=false)
savefig("sierpinsky.eps")


d, N, ε = box_counting_dimension(s, 10)

loglog_regression(N,ε)


log(3)/log(2)

plot(-log.(ε), log.(N), xlabel="-ln ε", ylabel="ln N")

C, r = correlation_dimension(s)

loglog_regression(C[1:9],r[1:9])

plot(log.(r), log.(C), xlabel="ln r", ylabel="ln C")
