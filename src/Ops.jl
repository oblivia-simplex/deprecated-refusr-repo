module Ops

export mov, nand, nor

const mov = identity

nand(a, b) = ~(a & b)

nor(a, b) = ~(a | b)

end
