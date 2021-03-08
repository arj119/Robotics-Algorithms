state = {x = 0, y = 0, theta = 0}

-- GET VECTOR AND ROTATION TO WAYPOINT
function getMovementToWaypoint(Wx, Wy, state)
    -- Translation
    dx = Wx - state.x
    dy = Wy - state.y

    -- Rotation
    alpha = atan2(dy, dx)
    beta = alpha - state.theta

    -- Make sure beta is in range -pi < beta <= pi
    beta = fmod(beta, 2*math.pi)

    return dx, dy, beta
end

function setForwardStraightLine(dx, dy, state)
    vl = V_C
    vr = V_C
end

function setRotationOnSpotVelocity(beta, state)
    -- rotate left
    vl = -V_C
    vr = V_C
end
