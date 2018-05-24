using Turing: _hmc_step

include("unit_test_helper.jl")
include("simple_gauss.jl")

# Turing

mf = simple_gauss()
chn = sample(mf, HMC(2000, 0.05, 5))

println("mean of m: $(mean(chn[:m][1000:end]))")

# Plain Julia

stds = ones(θ_dim)
θ = randn(θ_dim)
lj = lj_func(θ)

chn = Dict(:θ=>Vector{Vector{Float64}}(), :logϵ=>Vector{Float64}())
accept_num = 1

function dummy_print(args...)
  nothing
end

totla_num = 5000
for iter = 1:totla_num

  push!(chn[:θ], θ)
  θ, lj, is_accept, τ_valid, α = _hmc_step(θ, lj, lj_func, grad_func, 5, 0.05, stds; dprint=dummy_print)
  accept_num += is_accept

end

@show lj
@show mean(chn[:θ])
samples_first_dim = map(x -> x[1], chn[:θ])
@show std(samples_first_dim)

@show accept_num / totla_num

# Unit tests