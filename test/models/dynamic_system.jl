using FlightMechanics.Models


@testset "Dynamic systems conversions" begin
    pos = EarthPosition(1000.0, 500.0, -1000.0)
    att = Attitude(π/4, π/32, π/8)
    vel = [100.0, 0.0, 0.0]
    ang_vel = [π/90, π/18, π/9]
    accel = [1.5, 0.3, 0.5]
    ang_accel = [π/45, π/60, π/30]
    state = State(pos, att, vel, ang_vel, accel, ang_accel)

    # SixDOFEulerFixedMass
    x = convert(SixDOFEulerFixedMass, state)
    state_ = convert(state, x)
    @test isapprox(state, state_)

    # SixDOFQuaternionFixedMass
    x = convert(SixDOFQuaternionFixedMass, state)
    state_ = convert(state, x)
    @test isapprox(state, state_)

    # SixDOFAeroEulerFixedMass
    x = convert(SixDOFAeroEulerFixedMass, state)
    state_ = convert(state, x)
    @test isapprox(state, state_)

    # SixDOFECEFQuaternionFixedMass
    pos_ecef = convert(ECEFPosition, pos)
    state = State(pos_ecef, att, vel, ang_vel, accel, ang_accel)
    x = convert(SixDOFECEFQuaternionFixedMass, state)
    state_ = convert(state, x)
    @test isapprox(state, state_)
end
