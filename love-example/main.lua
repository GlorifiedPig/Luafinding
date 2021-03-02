
function printTable( tbl )
    for k, v in pairs( tbl ) do
        print( k, v )
    end
end

local profile = require( "profile" )
require( "vector" )
require( "luafinding" )

local map = {}

local mapSize = 50
local screenSize = 860
local tileSize = screenSize / mapSize

local path, reconstruction = nil
local start = Vector( 1, 1 )
local finish = Vector( mapSize, mapSize )

local clickedTile = nil

local function updatePath()
    path, reconstruction = Luafinding.FindPath( start, finish, map )
end

local function randomizeMap()
    for x = 1, mapSize do
        map[x] = {}
        for y = 1, mapSize do
            map[x][y] = true
        end
    end

    math.randomseed( os.clock() )
    for i = 1, math.random( 20, 100 ) do
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

    updatePath()
end

local runPerformanceTest = false
local timesToRun = 100
function love.load()
    love.window.setMode( screenSize, screenSize )
    randomizeMap()

    if runPerformanceTest then
        profile.start()
        local startTime = love.timer.getTime()
        local oneTime = love.timer.getTime()
        for i = 1, timesToRun do
            math.randomseed( os.clock() )
            local startPos = Vector( math.random( 1, mapSize ), math.random( 1, mapSize ) )
            local endPos = Vector( math.random( 1, mapSize ), math.random( 1, mapSize ) )
            local foundPath = Luafinding.FindPath( startPos, endPos, map )
            local newOneTime = love.timer.getTime()
            print( "Test #" .. i .. " took " .. newOneTime - oneTime .. " seconds.\nPath found: " .. tostring( type( foundPath ) == "table" ) .. "\nStart Position: " .. tostring( startPos ) .. "\nEnd Position: " .. tostring( endPos ) .. "\n\n" )
            oneTime = newOneTime
        end
        local timeTaken = love.timer.getTime() - startTime
        print( "It took " .. timeTaken .. " seconds to run the pathfinding test " .. timesToRun .. " times." )
        profile.stop()
        print( "\n\nprofile.lua report:\n" .. profile.report( 10 ) )
    end
end

function love.draw()
    love.graphics.setColor( 0.3, 0.3, 0.3 )
    for x = 1, mapSize do
        for y = 1, mapSize do
            local fillStyle = "line"
            if not map[x][y] then fillStyle = "fill" end
            love.graphics.rectangle( fillStyle, ( x - 1 ) * tileSize, ( y - 1 ) * tileSize, tileSize, tileSize )
        end
    end

    if path then
        love.graphics.setColor( 0, 0.3, 0 )
        for k, v in pairs( reconstruction ) do
            if v then
                love.graphics.rectangle( "fill", ( v.x - 1 ) * tileSize, ( v.y - 1 ) * tileSize, tileSize, tileSize )
            end
        end
        love.graphics.setColor( 0, 0.8, 0 )
        for k, v in pairs( path ) do
            love.graphics.rectangle( "fill", ( v.x - 1 ) * tileSize, ( v.y - 1 ) * tileSize, tileSize, tileSize )
        end
        love.graphics.setColor( 0, 0, 0 )
    end
end

function love.keypressed( key )
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        randomizeMap()
    end
end

function love.mousepressed( x, y, button )
    if button == 1 then
        local hoveredTile = Vector( math.floor( x / tileSize ) + 1, math.floor( y / tileSize ) + 1 )
        if not clickedTile then
            clickedTile = hoveredTile
            return
        end
        start = clickedTile
        finish = hoveredTile
        clickedTile = nil
        hoveredTile = nil
        updatePath()
    end
end