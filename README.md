# Luafinding
Luafinding is an A* module written in Lua with the main purposes being ease of use & optimization.

### Performance Tests
To run a performance test yourself, see `performance/performance.lua`. Move `luafinding.lua`, `vector.lua` and `heap.lua` to that folder and run `performance.lua` in your console. Here are my performance results:

```md
luajit performance.lua
Using seed 1614795006
Building 100x100 sized map.
Generating 2000 random start/finish positions.
Finding 1000 paths.
Done in 0.309 seconds.
Average of 0.000309 per path.
```

To compare, "lua-star" runs at an average of 0.0017 seconds per path on my machine; that's an **81.8% improvement** from one of the mainstream Love2D pathfinding methods.

### Love2D Implementation
To see an example of how this is implemented in Love2D, navigate to the `love2d-example` folder.
