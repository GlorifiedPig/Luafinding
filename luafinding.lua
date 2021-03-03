
-- Positions must be a table (or metatable) where table.x and table.y are accessible.

require( "vector" )
require( "heap" )

Luafinding = {}

local function distance( start, finish )
    local dx = start.x - finish.x
    local dy = start.y - finish.y
    return dx * dx + dy * dy
end

--[[
This could maybe be used in the future for shorter distances for more precise measurements, although the above function seems to work much faster and mostly fine.

local short_axis_cost = math.sqrt( 2 ) - 1

local function distance( start, finish )
    local x = math.abs( start.x - finish.x )
    local y = math.abs( start.y - finish.y )
    return short_axis_cost * math.min( x, y ) + math.max( x, y )
end
]]--

local function positionIsOpen( pos, check )
    if type( check ) == "table" then
        return check[pos.x] and check[pos.x][pos.y]
    elseif type( check ) == "function" then
        return check( pos.x, pos.y ) or true
    end

    return true
end

local adjacentPositions = {
    Vector( 0, -1 ),
    Vector( -1, 0 ),
    Vector( 0, 1 ),
    Vector( 1, 0 ),
    Vector( -1, -1 ),
    Vector( 1, -1 ),
    Vector( -1, 1 ),
    Vector( 1, 1 )
}

local function fetchOpenAdjacentNodes( pos, positionOpenCheck )
    local result = {}

    for i = 1, #adjacentPositions do
    	local adjacent = adjacentPositions[i]
        local adjacentPos = pos + adjacent
        if positionIsOpen( adjacentPos, positionOpenCheck ) then
            table.insert( result, adjacentPos )
        end
    end

    return result
end

-- positionOpenCheck can be a function or a table.
-- If it's a function it must have a return value of true or false depending on whether or not the position is open.
-- If it's a table it should simply be a table of values such as "pos[x][y] = true".
function Luafinding.FindPath( start, finish, positionOpenCheck )
    if not positionIsOpen( finish, positionOpenCheck ) then return end
    local open, previousTbl, closed, gScore, hScore, fScore, reconstruction = Heap(), {}, {}, {}, {}, {}, {}

    previousTbl[start] = false
    gScore[start] = 0
    hScore[start] = distance( start, finish )
    fScore[start] = hScore[start]

    open.Compare = function( a, b )
        return fScore[a] < fScore[b]
    end

    open:Push( start )

    while not open:Empty() do
        local current = open:Pop()
        local currentId = current:ID()
        if not closed[currentId] then
            reconstruction[currentId] = previousTbl[current]

            if current == finish then
                local path = { current }
                while reconstruction[path[#path]:ID()] do
                    path[#path + 1] = reconstruction[path[#path]:ID()]
                end
                for i = 1, math.floor( #path / 2 ) do path[i], path[#path - i + 1] = path[#path - i + 1], path[i] end
                return path, reconstruction
            end

            closed[currentId] = true

            local adjacents = fetchOpenAdjacentNodes( current, positionOpenCheck )
            for i = 1, #adjacents do
                local adjacent = adjacents[i]
                if not closed[adjacent:ID()] then
                    local added_gScore = gScore[current] + distance( current, adjacent )

                    if not gScore[adjacent] or added_gScore < gScore[adjacent] then
                        gScore[adjacent] = added_gScore
                        if not hScore[adjacent] then
                            hScore[adjacent] = distance( adjacent, finish )
                        end
                        fScore[adjacent] = added_gScore + hScore[adjacent]

                        open:Push( adjacent )
                        previousTbl[adjacent] = current
                    end
                end
            end
        end
    end
end