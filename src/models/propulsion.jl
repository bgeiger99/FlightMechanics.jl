abstract type Engine end

get_engine_position(eng::Engine) = [0, 0, 0]
get_engine_orientation(eng::Engine) = [0, 0, 0]
calculate_engine(eng::Engine) = error("abstract method")
get_engine_gyro_effects(eng::Engine) = [0.0, 0.0, 0.0]  # [kg·m²/s]

#Getters
get_pfm(eng::Engine) = eng.pfm
get_cj(eng::Engine) = eng.cj
get_power(eng::Engine) = eng.power
get_efficiency(eng::Engine) = eng.efficiency
get_tanks(eng::Engine) = eng.tanks
get_gyro_effects(eng::Engine) = eng.h  # angular momentum [kg·m²/s]


struct Propulsion
    pfm::PointForcesMoments
    cj::Number
    power::Number
    efficiency::Number
    engines::Array{Engine, 1}
    # Gyroscopic effects
    h::Array{T, 1} where T<:Number  # angular momentum [kg·m²/s]
end


# Getters
get_pfm(prop::Propulsion) = prop.pfm
get_cj(prop::Propulsion) = prop.cj
get_power(prop::Propulsion) = prop.power
get_efficiency(prop::Propulsion) = prop.efficiency
get_engines(prop::Propulsion) = prop.engines
get_gyro_effects(prop::Propulsion) = prop.h


function get_propulsion_position(prop::Propulsion)
    pos = [0.0, 0.0, 0.0]
    engines = get_engines(prop)
    for eng=engines
        pos += get_engine_position(eng)
    end
    return pos / length(engines)
end

function get_tanks(prop::Propulsion)
    tanks = RigidSolid[]
    for eng=get_engines(prop)
        for t=get_tanks(eng)
            push!(tanks, t)
        end
    end
    return tanks
end


get_fuel_mass_props(prop::Propulsion) = sum(get_tanks(prop))


function calculate_propulsion(
    prop::Propulsion, fcs::FCS, aerostate::AeroState, state::State; consume_fuel=false
    )

    engines = get_engines(prop)

    power = 0.
    pfm = PointForcesMoments(get_propulsion_position(prop), [0, 0, 0], [0, 0, 0])
    cj = 0
    efficiency = 0
    gyro = [0.0, 0.0, 0.0]

    for (ii, eng)=enumerate(engines)
        engines[ii] = calculate_engine(eng, fcs, aerostate, state;
                                       consume_fuel=consume_fuel)
        # TODO: use get_engine_orientation and rotate every engine pfm to body
        pfm += rotate(get_pfm(engines[ii]), get_engine_orientation(eng)...)
        power += get_power(engines[ii])
        gyro += get_gyro_effects(engines[ii])
        # TODO: cj and efficiency
    end

    Propulsion(pfm, cj, power, efficiency, engines, gyro)
end
