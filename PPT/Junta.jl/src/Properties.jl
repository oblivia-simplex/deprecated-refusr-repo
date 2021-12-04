module Properties

export PointwisePropertyTest, is_monotonic

mutable struct PointwisePropertyTest
    test :: Function
    # test takes the function f under study and two inputs differing in one bit
    # and returns true iff the property holds between those inputs for f
    log :: Vector{Tuple{BitVector, Integer, Bool}}
    # log records input BitVector, position of the flipped bit, and whether
    # the property tested by the "test" function held at that point
    log_lock :: ReentrantLock
end

PointwisePropertyTest(f, l) = PointwisePropertyTest(f, l, ReentrantLock())
PointwisePropertyTest(f) = PointwisePropertyTest(f, Vector())

function is_monotonic(f :: Function, x :: BitVector, y :: BitVector)
    # This test as written will only work when x and y differ by 1 bit
    # (which is true in this context) because of use of sort.
    (a, b) = sort([x, y])
    if f(a) ≤ f(b)
        return true
    end
    return false
end

end # module Properties
