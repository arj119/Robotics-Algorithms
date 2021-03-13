function StoreSignature()
    Signature = {}
    for i=1, 360 do
        angle = i - 1 -- 1 indexing from lua
        if (angle > 180) then 
            angle = angle - 360
        end
        
        SetSonarAngle(angle)
        Signature[i] = GetSonarDepth()
    end
    return Signature
end

StoredSignatures = {} -- sonar 360 depth readings

function RecognisePlace()
    Signature = StoreSignature()
    minDiff = math.huge
    place = -1
    for p=1, #StoredSignatures do 
        diff = HistogramDifference(Signature, StoredSignatures[p])
        if(diff < minDiff) then
            minDiff = diff
            place = p
        end
    end
    
    if(minDiff > MAX_PLACE_DISTANCE_THRESHOLD) then
        return -1
    else
        return place
    end
end

function HistogramDifference(h1, h2, offset=0) -- exclude offset if not needed
    sum = 0
    for i=1, #h1 do
        idx = ((i + offset) % #h1) + 1 -- remove + 1 for zero indexing
        sum = sum + (h1[idx] - h2[idx]) ^ 2
    end
    
    return sum
end

function HistogramDifferenceAndOrientation(h1, h2)
    sensorAngleBetweenReading = 360 / #h1 

    minDiff = math.huge
    orientation = 0
    for i=0, #h1-1 do
        diff = HistogramDifference(h1, h2, offset=i)
        if(diff < minDiff) then
            minDiff = diff
            orientation = math.rad(sensorAngleBetweenReading * i)
        end
    end

    -- Omit if unecessary
    if orientation > math.pi then
        orientation = orientation - 2 * math.pi
    elseif orientation < -math.pi then
        orientation = orientation + 2 * math.pi 
    end
    
    return minDiff, orientation
end

--DEPTH HISTOGRAM
q = 5 -- quantisation
MAX_DEPTH, MIN_DEPTH -- extreme values for sensor
function ConvertToDepthHistogram(Signature)
    depthHist = {}
    for i=1, math.floor((MAX_DEPTH - MIN_DEPTH) / q) do
        depthHist = 0
    end

    for i=1, #Signature do
        idx = math.floor(Signature[i] / q)
        depthHist[idx] = depthHist[idx] + 1
    end
    return depthHist
end