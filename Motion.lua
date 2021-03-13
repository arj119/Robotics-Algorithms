function DriveToWaypoint(Wx, Wy, state)
    dX = Wx - state.x
    dY = Wy - state.y

    -- distance to drive forward
    D = math.sqrt(dX ^ 2 + dY ^ 2)

    -- angle to rotate through
    alpha = math.atan2(dY, dX) - state.theta
    if(alpha > math.pi) then
        alpha = alpha - 2 * math.pi
    elseif(alpha < - math.pi) then
        alpha = alpha - 2 * math.pi
    end

    RotateRobot(alpha)
    DriveRobotForward(D)

    return D, alpha
end