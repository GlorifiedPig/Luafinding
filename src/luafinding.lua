
-- Positions must be a table (or metatable) where table.x and table.y are accessible.

local Vector = require( "vector" )
local Heap = require( "heap" )

local Luafinding = {}

local function distance( start, finish )
    local dx = start.x - finish.x
    local dy = start.y - finish.y
    return dx * dx + dy * dy
end

local positionIsOpen
local function positionIsOpenTable( pos, check ) return check[pos.x] and check[pos.x][pos.y] end
local function positionIsOpenCustom( pos, check ) return check( pos ) or true end

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
    if not positionOpenCheck then return end
    positionIsOpen = type( positionOpenCheck ) == "table" and positionIsOpenTable or positionIsOpenCustom
    if not positionIsOpen( finish, positionOpenCheck ) then return end
    local open, closed = Heap(), {}

    start.gScore = 0
    start.hScore = distance( start, finish )
    start.fScore = start.hScore

    open.Compare = function( a, b )
        return a.fScore < b.fScore
    end

    open:Push( start )

    while not open:Empty() do
        local current = open:Pop()
        local currentId = current:ID()
        if not closed[currentId] then
            if current == finish then
                local path = {}
                while true do
                    if current.previous then
                        table.insert( path, 1, current )
                        current = current.previous
                    else
                        table.insert( path, 1, start )
                        return path
                    end
                end
            end

            closed[currentId] = true

            local adjacents = fetchOpenAdjacentNodes( current, positionOpenCheck )
            for i = 1, #adjacents do
                local adjacent = adjacents[i]
                if not closed[adjacent:ID()] then
                    local added_gScore = current.gScore + distance( current, adjacent )

                    if not adjacent.gScore or added_gScore < adjacent.gScore then
                        adjacent.gScore = added_gScore
                        if not adjacent.hScore then
                            adjacent.hScore = distance( adjacent, finish )
                        end
                        adjacent.fScore = added_gScore + adjacent.hScore

                        open:Push( adjacent )
                        adjacent.previous = current
                    end
                end
            end
        end
    end
end

return Luafinding