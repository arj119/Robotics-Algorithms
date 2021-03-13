-- Occupancy Grid Mapping at occupancyMap[x][y] the log odds of it being occupied is stored
SONAR_BEAM_HALF_WIDTH = 5
SONAR_DEPTH_SIGMA = 4
function UpdateOccupancyMap(x, y, theta, z, alpha)
    for globalX=1,GRID_SIZE do
        for globalY=1,GRID_SIZE do
            -- Get translation vector to cell from robot position
            transX = globalX - x 
            transY = globalY - y
       
            if (IsWithinBeam(transX, transY, theta + alpha, SONAR_BEAM_HALF_WIDTH)) then
                -- Update log odds 
                cellD = math.sqrt(transX ^ 2 + transY ^ 2)

                if (math.abs(z - cellD) < SONAR_DEPTH_SIGMA) then
                    -- cell is within region of high occupied likelihood
                    occupancyMap[globalX][globalY] = occupancyMap[globalX][globalY] + 5
                elseif (cellD < z - SONAR_DEPTH_SIGMA) then
                    -- cell is within region of high empty likelihood 
                    occupancyMap[globalX][globalY] = occupancyMap[globalX][globalY] - 2
                end
            end
        end
    end
end

function IsWithinBeam(cellX, cellY, z, angle, halfWidth) then
    beamX = z * math.cos(theta + alpha)
    beamY = z * math.sin(theta + alpha)

    dotProduct = cellX * beamX + cellY * beamY
    cellD = math.sqrt(cellX ^ 2 + cellY ^ 2)
    
    -- cosine distance
    angleToBeam = math.acos(dotProduct / (cellD * z))
    return angleToBeam <= halfWidth
end