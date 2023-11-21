# Implement AlgebraicVector using Julia Vector

"""
    Base.sin(x::Vector{DA})::Vector{DA}

Compute the sine of a Vector{DA}. The result is
copied to a new Vector{DA}.
"""
function Base.sin(x::Vector{DA})::Vector{DA}
    temp = Vector{DA}(undef, length(x))
    for i in 1:length(x)
        temp[i] = sin(x[i])
    end

    return temp
end


"""
    gradient(x::DA)::Vector{DA}

Compute the gradient of the DA object. Returns a Vector{DA}
containing the derivatives of the DA object with respect to all
independent DA variables.
"""
function gradient(x::DA)::Vector{DA}
    nvar = getmaxvariables()
    temp = Vector{DA}(undef, nvar)
    for i in 1:nvar
        temp[i] = deriv(x, i)
    end

    return temp
end


"""
    Base.show(io::IO, vec::Vector{DA})

Print Vector of DA objects
"""
function Base.show(io::IO, vec::Vector{DA})
    #print(io, tostring(da))
    size = length(vec)
    print(io, "[[[ ")
    print(io, size)
    println(io, " vector")
    for i in 1:size
        println(io, vec[i])
    end
    println(io, "]]]")
end
