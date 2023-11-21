# Implement AlgebraicVector using Julia Vector

function Base.sin(x::Vector{DA})::Vector{DA}
    temp = Vector{DA}(undef, length(x))
    for i in 1:length(x)
        temp[i] = sin(x[i])
    end

    return temp
end


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
