-- Get likelihood of particles from compass bearing beta with uncertainty std_compass
-- beta: 0 = north, 90 = east,...
function GetCompassLikelihood(particle, beta)
    -- transform compass bearing to be in same scheme as robot coordinate theta
    betaWorld = 90 - beta
    if(betaWorld< -179) then
        betaWorld = betaWorld + 360
    end

    return math.exp((-(betaWorld - particle.theta) ^ 2) / (2 * std_compass ^ 2))
end