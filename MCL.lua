-- MCL
N = 100
function InitialiseParticleSet() 
    xArray = {}
    yArray = {}
    thetaArray = {}
    weightArray = {}

    for i=1,N do
        -- Replace with origin angle
        xArray[i] = 0
        yArray[i] = 0
        thetaArray[i] = 0
        weightArray[i] = 1/N
    end
end

-- Either robot moves D forward or turns alpha
-- Tunable error terms
std_e = 0.4
std_f = 0.6
std_g = 0.5
function MotionPrediction(D, alpha) 
    if(alpha == 0) then
        for i=1,N do
            e = gaussian(0, D * (std_e ^ 2))
            xArray[i] = xArray[i] + ((D + e) * math.cos(thetaArray[i]))
            yArray[i] = yArray[i] + ((D + e) * math.sin(thetaArray[i]))
            f =  gaussian(0, std_f ^ 2)
            thetaArray[i] = thetaArray[i] + f
        end
        --updateDummyWeights(z)
    elseif(D == 0) then
        for i=1, N do
            g = gaussian(0, math.abs(alpha / math.pi) * (std_g ^ 2))
            thetaArray[i] = thetaArray[i] + alpha + g
        end
        --updateDummyWeights(z)
    end
end

function MeasurementLikelihoodUpdate(z) 
    for i=1, N do 
        -- inner for loop for multiple sensor readings
        for j=1, #z do
            angleOffset = (i - 1) *  math.rad(360 / #z)
            weightArray[i] = 
                weightArray[i] * CalculateLikelihood(xArray[i], yArray[i], thetaArray[i] + angleOffset, z)
        end
    end
end

function CalculateLikelihood(x, y, theta, z)
    minMValue = math.huge
    wallIndex = -1
    for i=1, #walls do 
        Ax, Ay, Bx, By = walls[i][1], walls[i][2], walls[i][3], walls[i][4]
        -- replace with other m calculation where necessary
        m = (((By - Ay) * (Ax - x)) - ((Bx - Ax) * (Ay - y))) / (((By - Ay) * math.cos(theta)) - ((Bx - Ax) * math.sin(theta)))
        -- get rid of backwards values
        if (m > 0) then 
            intersectionX = x + m * math.cos(theta)
            intersectionY = y + m * math.sin(theta)
            fullLineDistance = distanceSquared(Ax, Ay, Bx, By)
            distanceAtoPoint = distanceSquared(Ax, Ay, intersectionX, intersectionY)
            distancePointtoB = distanceSquared(intersectionX, intersectionY, Bx, By)
            if (distanceAtoPoint + distancePointtoB == fullLineDistance) then
                if (m < minMValue) then
                    minMValue = m
                    wallIndex = i
                end
            end
        end
    end
        
    return math.exp((-(z - minMValue) ^2) / (2 * sensorVariance))
end

function NormaliseParticleSetWeights() 
    weightSum = 0
    for i=1, N do 
        weightSum = weightSum + weightArray[i]
    end

    for i=1, N do 
        weightArray[i] = weightArray[i] / weightSum
    end
end

function ResampleParticleSet()
    xArrayNew = {}
    yArrayNew = {}
    thetaArrayNew = {}

    for i=1, N do
        randomNumber = math.random()
        for j=1, N do
            randomNumber = randomNumber - weightArray[j]
            if (randomNumber <= 0.0) then
                xArrayNew[i] = xArray[j] 
                yArrayNew[i] = yArray[j] 
                thetaArrayNew[i] = thetaArray[j] 
                break
            end
        end 
    end

    for i=1, N do
        xArray[i] = xArrayNew[i]
        yArray[i] = yArrayNew[i]
        thetaArray[i] = thetaArrayNew[i]
        weightArray[i] = 1 / N
    end
end

function distanceSquared(aX, aY, bX, bY) 
    return math.sqrt(((aX - bX) ^ 2) + ((aY - bY) ^ 2))
end