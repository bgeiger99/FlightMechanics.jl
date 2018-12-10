using FlightMechanics.Simulator.Models


@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end


# Constructor
rs = RigidSolid(15.0, [1.0, 1.0, 1.0], Matrix(1.0I, 3, 3))
@test isapprox(15.0, rs.mass)
@test isapprox([1.0, 1.0, 1.0], rs.cg)
@test isapprox(Matrix(1.0I, 3, 3), rs.inertia)

# Constructor
pm = PointMass(15.0, [1.0, 1.0, 1.0])
@test isapprox(15.0, pm.mass)
@test isapprox([1.0, 1.0, 1.0], pm.cg)
@test isapprox(zeros(3, 3), pm.inertia)

# Getters
@test isapprox(rs.mass, get_mass(rs))
@test isapprox(rs.cg, get_cg(rs))
@test isapprox(rs.inertia, get_inertia(rs))

# get_inertia in other point (Steiner's theorem)
mass = 10
point0 = [0, 0, 0]
inertia = [1 0 0;
           0 2 0;
           0 0 3]

rs = RigidSolid(mass, point0, inertia)
point1 = [10, 0, 0]
inertia_p1 = get_inertia(rs, point1)

exp_inertia = [0       0     0;
               0    1000     0;
               0       0  1000] + inertia
@test isapprox(inertia_p1, exp_inertia)
