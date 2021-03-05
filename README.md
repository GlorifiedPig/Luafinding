# Luafinding

Luafinding is an A* module written in Lua with the main purposes being ease of use & optimization.

### Performance Tests

To run a performance test yourself, see `performance/performance.lua`. Move all the Lua files in `src/` to that folder and run `performance.lua` in your console. Here are my performance results:

```md
> luajit performance.lua
Using seed 1614795006
Building 100 x 100 sized map.
Generating 2000 random start/finish positions.
Finding 1000 paths.
Done in 0.309 seconds.
Average of 0.000309 per path.
```

To compare, "lua-star" runs at an average of 0.0017 seconds per path on my machine for a 100x100 map; that's an **81.8% improvement** from one of the mainstream Love2D pathfinding methods.

Not to mention that a lot of Love2D implementations also feature a lot of `O(n)` for tables instead of indexing. When testing "lua-star" in Love2D, it ran at about 2 seconds per path - whereas Luafinding, on my machine, runs at 0.00034 seconds per path. That's an **entire 99.98% decrease in computing time.**

### Love2D Implementation

To see an example of how this is implemented in Love2D, navigate to the `love2d-example` folder.

![Luafinding in action](https://user-images.githubusercontent.com/7416288/109854935-546bfd00-7c60-11eb-8476-98308bfeb3c0.png)
