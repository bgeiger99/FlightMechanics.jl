# --------- Control ---------
abstract type Control end

get_value(c::Control) = c.value

# --------- RangeControl ---------
mutable struct RangeControl<:Control
    value::Number
    value_min::Number
    value_max::Number
end

RangeControl(value, value_range) = RangeControl(value, value_range[1], value_range[2])

get_value_range(c::RangeControl) = (c.value_min, c.value_max)

copy(rc::RangeControl) = RangeControl(rc.value, rc.value_min, rc.value_max)

# TODO: for trimmer to work, values out of the domain are allowed.
# an optimization method with boundaries must be sought
function set_value!(c::RangeControl, val, allow_out_of_range=false, throw_error=false)
    if allow_out_of_range
        c.value = val
    else
        min, max = get_value_range(c)
        if min <= val <= max
            c.value = val
        else
            if throw_error
                throw(DomainError(val, "val must be between min and max"))
            elseif val < min
                c.value = min
            else
                c.value = max
            end
        end
    end
end


# --------- DiscreteControl ---------
mutable struct DiscreteControl<:Control
    value::Int
    value_choices::Array{Int, 1}
end

get_value_choices(c::DiscreteControl) = c.value_choices

function set_value!(c::DiscreteControl, val)
    if val in get_value_choices(c)
        c.value = val
    else
        throw(DomainError(val, "val not in discrete control options"))
    end
end

copy(dc::DiscreteControl) = DiscreteControl(dc.value, copy(dc.value_choices))
