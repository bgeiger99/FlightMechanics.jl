using FlightMechanics
import Base: +


# TODO: provide outer constructor checking dimensions?
struct RigidSolid
    mass::Number
    cg::Array{T, 1} where T<:Number
    inertia::Array{T, 2} where T<:Number
end


function PointMass(mass::Number, position::Array{T, 1}) where T<:Number
    RigidSolid(mass, position, zeros(3, 3))
end


get_mass(component::RigidSolid) = component.mass
get_cg(component::RigidSolid) = component.cg
get_inertia(component::RigidSolid) = component.inertia


function get_inertia(component::RigidSolid, point::Array{T, 1})
    steiner_inertia(component.cg, component.inertia, component.mass, point)
end

function +(comp1::RigidSolid, comp2::RigidSolid)
    mass = comp1.mass + comp2.mass
    cg = (comp1.cg*comp1.mass + comp2.cg*comp2.mass) / (comp1.mass + comp2.mass)
    inertia = get_inertia(comp1, cg) + get_inertia(comp2, cg)
    RigidSolid(mass, cg, inertia)
end
