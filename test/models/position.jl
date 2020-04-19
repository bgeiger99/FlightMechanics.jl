using Test
using FlightMechanics.Models
using FlightMechanics


llh = [deg2rad(49.996908), 0.000000, 9907.31]
xyz_ecef = [4114496.258, 0.0, 4870157.031]
xyz_earth = [0., 0., -9907.31]

pllh = PositionLLH(llh...)

@test isapprox(get_llh(pllh), llh)
@test isapprox(get_xyz_earth(pllh), xyz_earth)
@test isapprox(get_xyz_ecef(pllh), xyz_ecef)
@test isapprox(get_height(pllh), llh[3])

xyz_earth = [0., 0., -9907.31]
pearth = PositionEarth(xyz_earth..., llh[1:2]...)

@test isapprox(get_llh(pearth), llh)
@test isapprox(get_xyz_earth(pearth), xyz_earth)
@test isapprox(get_xyz_ecef(pearth), xyz_ecef)
@test isapprox(get_height(pearth), -xyz_earth[3])


pecef = PositionECEF(xyz_ecef...)

@test isapprox(get_llh(pecef), llh, rtol=1e-5)
@test isapprox(get_xyz_earth(pecef), xyz_earth, rtol=1e-5)
@test isapprox(get_xyz_ecef(pecef), xyz_ecef)
@test isapprox(get_height(pecef), llh[3], atol=0.17)

pzero = Position()

@test isapprox(get_llh(pzero), [0, 0, 0])
@test isapprox(get_xyz_earth(pzero), [0, 0, 0])
@test isapprox(get_xyz_ecef(pzero), llh2ecef(0, 0, 0))
@test isapprox(get_height(pzero), 0)


# Start Earth come back from ECEF and LLH
ref_llh = LLHPosition(π/4, π/3, 0.0)
earth = EarthPosition(1000.0, 300.0, 5000.0, ref_llh)

llh = convert(LLHPosition, earth)
earth_from_llh = convert(earth, llh)
@test isapprox(earth, earth_from_llh)

ecef = convert(ECEFPosition, earth)
earth_from_ecef = convert(earth, ecef)
@test isapprox(earth, earth_from_ecef)

# Start LLH come back from Earth and ECEF
llh = LLHPosition(π/4, π/3, 1000.0)

earth = convert(EarthPosition(ref_llh), llh)
llh_from_earth = convert(LLHPosition, earth)
@test isapprox(llh, llh_from_earth)

ecef = convert(ECEFPosition, llh)
llh_from_ecef = convert(llh, ecef)
@test isapprox(llh, llh_from_ecef)

# Start ECEF come back from Earth and LLH
ecef = ECEFPosition(2.25e6, 3.91e6, 4.48e6)

llh = convert(LLHPosition(WGS84), ecef)
ecef_from_llh = convert(ECEFPosition, llh)
@test isapprox(ecef, ecef_from_llh)

earth = convert(EarthPosition(ref_llh), ecef)
ecef_from_earth = convert(ECEFPosition, earth)
@test isapprox(ecef, ecef_from_earth)
