-- Get likelihood for camera that can observe and get angle to landmark
-- landmarks are known by id
-- observations stores a list of observations alpha - angle and id - landmark id

function GetCameraLikelihood(particle, observations)
    likelihood = 1
    for i=1, #observations do
        l = landmarks[observations[i].id]
        -- Get translation vector from particle
        dy = l.y - particle.y
        dx = l.x - particle.x

        -- Angle between particle and landmark
        particleAlpha = math.atan2(dy, dx) - particle.theta

        likelihood = likelihood * math.exp((-(observations[i].alpha - particleAlpha) ^ 2) / (2 * std_camera ^ 2))
    end
    return likelihood 
end