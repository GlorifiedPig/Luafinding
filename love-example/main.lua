
require( "vector" )
require( "luafinding" )

local map = {}

local mapSize = 3000
local function randomizeMap()
    for x = 1, mapSize do
        map[x] = {}
        for y = 1, mapSize do
            map[x][y] = true
        end
    end

    math.randomseed( os.clock() )
    for i = 1, 45 do
        local x = math.random( 1, mapSize - 2 )
        local y = math.random( 1, mapSize - 2 )

        if math.random() > 0.5 then
            for n = 1, 5 do
                map[x][math.min( mapSize, y + n )] = false
            end
        else
            for n = 1, 5 do
                map[math.min( mapSize, x + n )][y] = false
            end
        end
    end
end

local timesToRun = 1000
function love.load()
    randomizeMap()
    local startTime = love.timer.getTime()
    for i = 1, timesToRun do
        math.randomseed( os.clock() - math.random( 1, 10 ) )
        Luafinding.FindPath( Vector( math.random( 1, mapSize ) ), Vector( math.random( 1, mapSize ) ), map )
    end
    local timeTaken = love.timer.getTime() - startTime
    print( "It took " .. timeTaken .. " seconds to run the pathfinding test " .. timesToRun .. " times." )
end