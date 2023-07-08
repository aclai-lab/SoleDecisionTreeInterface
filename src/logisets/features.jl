import Base: isequal, hash, show
import SoleLogics: syntaxstring

"""
    abstract type AbstractFeature end

Abstract type for features of worlds of
[Kripke structures](https://en.wikipedia.org/wiki/Kripke_structure_(model_checking).

See also [`VarFeature`](@ref), [`featvaltype`](@ref), [`AbstractWorld`](@ref).
"""
abstract type AbstractFeature end

function syntaxstring(f::AbstractFeature; kwargs...)
    return error("Please, provide method syntaxstring(::$(typeof(f)); kwargs...)."
        * " Note that this value must be unique.")
end

function Base.show(io::IO, f::AbstractFeature)
    # print(io, "Feature of type $(typeof(f))\n\t-> $(syntaxstring(f))")
    print(io, "$(typeof(f)): $(syntaxstring(f))")
    # print(io, "$(syntaxstring(f))")
end

Base.isequal(a::AbstractFeature, b::AbstractFeature) = syntaxstring(a) == syntaxstring(b)
Base.hash(a::AbstractFeature) = Base.hash(syntaxstring(a))

function parsefeature(
    FT::Type{<:AbstractFeature},
    expression::String;
    kwargs...
)
    return error("Please, provide method parsefeature(::$(FT), " *
        " expression::$(typeof(expression)); kwargs...).")
end

############################################################################################

"""
    struct Feature{A} <: AbstractFeature
        atom::A
    end

A feature solely identified by an atom (e.g., a string with its name,
a tuple of strings, etc.)

See also [`AbstractFeature`](@ref).
"""
struct Feature{A} <: AbstractFeature
    atom::A
end

syntaxstring(f::Feature; kwargs...) = string(f.atom)

function parsefeature(
    ::Type{Feature},
    expression::String;
    kwargs...
)
    Feature(expression)
end

############################################################################################

"""
    struct ExplicitFeature{T} <: AbstractFeature
        name::String
        featstruct
    end

A feature encoded explicitly as a slice of feature structure (see `AbstractFeatureLookupSet`).

See also
[`AbstractFeatureLookupSet`](@ref), [`AbstractFeature`](@ref).
"""
struct ExplicitFeature{T} <: AbstractFeature
    name::String
    featstruct::T
end
syntaxstring(f::ExplicitFeature; kwargs...) = f.name

############################################################################################