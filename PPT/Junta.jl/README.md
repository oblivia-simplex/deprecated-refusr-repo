# Junta.jl

## Introduction

Simple adaptive junta checker for boolean functions from Zhengyang Liu, Xi Chen, Rocco A. Servedio, Ying Sheng, and Jinyu Xie. 2018. Distribution-Free Junta Testing. In Proceedings of 50th Annual ACM SIGACT Symposium on the Theory of Computing (STOC’18). ACM, New York, NY, USA, 11 pages. [https://doi.org/10.1145/3188745.3188842]

Has some extensions / modifications to the algorithm in the paper to find the size of the junta automatically and efficiently, and to extract sample sets from the junta search that indicate points in the input space where the output is sensitive to the input, and to test properties at those points.

This in turn is used to implement comparison of functions by their behavior on those points as reflected by Hamming distance in fixed-size hash-like vectors that sketch the function behavior with respect to the tested property.

## Junta Search

The module JuntaSearch provides two functions by which to conduct a search for juntas, `junta_size_adaptive_simple` and `check_for_juntas_adaptive_simple`.

`junta_size_adaptive_simple` is the recommended way to use the library, and automatically finds the size of the junta as well as returning the input indices in the junta and, optionally, the log of sample points found to reveal that a certain bit position is in the junta.

`check_for_juntas_adaptive_simple` is the inner loop of the previous method, and can be used to query for a junta of a given size. It is included for completeness and compatibility with the concepts in the literature. It is a direct implementation of the so-named algorithm in the paper, with the aforementioned enhancements.

### Parameters

Not all functions take all of the following parameters, but each has the same meaning in each one where each appears.

 * `f :: Function` is the function to test
 * ``ϵ :: Real` is the distance parameter for test sensitivity in terms of a distance in function input space that sets the bound on the number of samples together with `error_prob`. See the paper for details.
 * `dim :: Integer` is the dimension of the input BitVector that the function `f` takes.
 * `error_prob :: Real` is the error bound for testing; an upper bound on the probability that any of the tests for a junta of a certain size will return a false negative (or the probability that the one test will, in the case of a test for a junta of a given size).
 * `testspec :: Union{PointwisePropertyTest, Nothing} = nothing` if provided, property test data stucture in which to store log of sensitive points, and optionally, property to test at those points.
 * `num_points :: Integer = 1` is the number of input points to accumulate at each index. It is appropriate to use the default value of 1 for junta checking but can be set to higher values to accumulate more samples for function characterization or comparison.
 * `rng = RNG_DEFAULT` is the rng to use. `Random.GLOBAL_RNG` by default.
 * `parblocksize :: Integer = PARBLOCK_DEFAULT` is the number of tests to run in parallel.

If running tests in parallel, run `Distributed.addprocs` after loading the `Junta` module to avoid errors related to the module not being loaded by workers.

## Property testing

Module `Properties` defines a struct used to conduct testing of _pointwise properties_, that is, properties that can be checked on two inputs which differ by exactly one bit, and for logging of the samples taken in the course of the junta search.

The struct is as follows:

```
mutable struct PointwisePropertyTest
    test :: Function
    # test takes the function f under study and two inputs differing in one bit
    # and returns true iff the property holds between those inputs for f
    log :: Vector{Tuple{BitVector, Integer, Bool}}
    # log records input BitVector, position of the flipped bit, and whether
    # the property tested by the "test" function held at that point
    log_lock :: ReentrantLock
end
```

The `log_lock` is used to secure the log when searching in parallel. It may be moved to an internal-only analog of this structure in the future.

## Function Similarity modulo Pointwise Property Test.

The `Fingerprint` module provides the function `fingerprint` for computing the fingerprint of a function in the form of a hash-like vector whose set bits reflect which points in a sample set a given pointwise property holds. It also provides the function `printcompare` which return the Hamming distance of those vectors computed for each of two functions on a merged sample set (so that both functions are characterized on the same set of samples).

### Parameters

#### `fingerprint`

 * `t :: Vector{Tuple{BitVector, Integer, Bool}}` is the sample set given in the same structure that the junta search produces.
 * `codesize = nothing` is the length of the code vector to use. It defaults to a the log base 2 of the sample set cardinality with a minimum of 64.

#### `crosstest`

 * `f1 :: Function, f2 :: Function,` are the two functions being compared.
 * `t1 :: PointwisePropertyTest, t2 :: PointwisePropertyTest` are the PointwisePropertyTest structures containing the sample sets and predicates used to test each of the two functions respectively which are merged and used as the basis for comparison.
 * `codesize` is as above.
