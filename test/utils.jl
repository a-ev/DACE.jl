function bernoulli(n)
    A = Vector{Rational{BigInt}}(undef, n + 1)
    for m = 0 : n
        A[m + 1] = 1 // (m + 1)
        for j = m : -1 : 1
            A[j] = j * (A[j] - A[j + 1])
        end
    end
    return A[1]
end
