
-- Positions must be a table (or metatable) where table.x and table.y are accessible.

Luafinding = {}

local function vector( x, y ) return { x = x, y = y } end

local function positionIsOpen( pos, check )
    if type( check ) == "table" then
        return check[pos.x] and check[pos.x][pos.y]
    elseif type( check ) == "function" then
        return check( pos.x, pos.y ) or true
    end

    return true
end

local adjacentPositions = { vector( 0, -1 ), vector( -1, 0 ), vector( 0, 1 ), vector( 1, 0 ), vector( -1, -1 ), vector( 1, -1 ), vector( -1, 1 ), vector( 1, 1 ) }
local function fetchOpenAdjacentNodes( pos, positionOpenCheck )
    local result = {}

    for _, adjacent in ipairs( adjacentPositions ) do
        local adjacentPos = vector( pos.x + adjacent.x, pos.y + adjacent.y )
        if positionIsOpen( adjacentPos, positionOpenCheck ) then
            table.insert( result, adjacentPos )
        end
    end

    return result
end

-- positionOpenCheck can be a function or a table.
-- If it's a function it must have a return value of true or false depending on whether or not the position is open.
-- If it's a table it should simply be a table of values such as "pos[x][y] = true".
function Luafinding:FindPath( start, goal, positionOpenCheck )
end