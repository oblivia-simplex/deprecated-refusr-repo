using BitTools, Test

@testset "rbitvec" begin
    l = 5
    @test length(rbitvec(l)) == l
end

@testset "invert_at_indices" begin
    b = BitVector([1, 0, 1, 0])
    @test invert_at_indices(b, [3,4]) == BitVector([1, 0, 0, 1])
end

@testset "bitfit estimate" begin
    data = BitMatrix(rand(Bool, 3, 1000))
    rightAnswer = Float64[1 1 1; 1 1 0; 1 0 1; 0 1 1; 0 0 0; 0 0 1; 0 1 0; 1 0 0]'
    rightAnswer = sortslices(rightAnswer, dims = 2)
    foundAnswer = sortslices(findClustering(data).centers, dims = 2)
    @test sum(rightAnswer .- foundAnswer .|> abs) < 1e4
end

@testset "bitfit sample" begin
    data = BitMatrix(rand(Bool, 3, 1000))
    c = findClustering(data)
    weights = sampleWeights(c, 10000)
    answer = sum(sample(c, 10000, 100000), dims = 2) ./ 100000
    @test sum(weights .- answer .|> abs) < 1e4
end

@testset "hypercodes" begin
    object = 42
    code = hypercode(object)
    @test length(code) == 4096
    @test sum(code) == 16
end
