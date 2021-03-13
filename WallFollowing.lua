function GetSonarDepthRobust()
    zs = {}
    for i=1,5 do 
        zs = GetSonarDepth()
    end
    return math.median(zs)
end

function ClipVelocity(lo, hi, v) 
    return math.max(lo, math.min(v, hi))
end

-- Follow wall with proportional control

update_freq = 20 -- Hz
v_c = 10
d = 30
k_p = ? -- to be set
while(true) do
    start_time = time.time()
    z = GetSonarDepthRobust()
    dv = k_p * (z - d)
    v_r = ClipVelocity(0, 20, v_c + dv)
    v_l = ClipVelocity(0, 20, v_c - dv)

    SetRightVelocity(v_r)
    SetLeftVelocity(v_l)

    time.sleep((1/update_freq) - (time.time() - start_time))
end

-- Follow wall with PID

update_freq = 20 -- Hz
v_c = 10
d = 30
k_p, k_i, k_d = ? -- to be set

prev_e = 0
prev_t = 0
integral = 0

while(true) do
    start_time = time.time()
    z = GetSonarDepthRobust()
    dv = CalculatePID(z, d, start_time)
    v_r = ClipVelocity(0, 20, v_c + dv)
    v_l = ClipVelocity(0, 20, v_c - dv)

    SetRightVelocity(v_r)
    SetLeftVelocity(v_l)

    time.sleep((1/update_freq) - (time.time() - start_time))
end

function CalculatePID(z, d, start_time)
    -- e(t)
    e = z - d 
    d_t = start_time - prev_t
    integral = integral + e * d_t
    derivative = (e - prev_e) / d_t

    -- u(t)
    u = k_p * e + k_i * integral + k_d * derivative
    
    prev_e = e
    prev_t = start_time
    return u 
end
