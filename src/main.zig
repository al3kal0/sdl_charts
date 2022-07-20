const std = @import("std");
const c = @import("c.zig");
const SDL = @import("sdl2.zig");

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    const flags = SDL.WindowFlags.Maximized;
    const window = SDL.CreateWindow("example", SDL.WindowPosCentered, SDL.WindowPosCentered, 800, 600, flags);
    defer SDL.DestroyWindow(window);
    const renderer = SDL.CreateRenderer(window, -1, SDL.RendererFlags.Accelarated);
    defer SDL.DestroyRenderer(renderer);

    // var vert: [3]c.SDL_Vertex = undefined;
// 
    // // center
    // vert[0].position.x = 400;
    // vert[0].position.y = 150;
    // vert[0].color.r = 255;
    // vert[0].color.g = 0;
    // vert[0].color.b = 0;
    // vert[0].color.a = 255;
// 
    // // left
    // vert[1].position.x = 200;
    // vert[1].position.y = 450;
    // vert[1].color.r = 0;
    // vert[1].color.g = 0;
    // vert[1].color.b = 255;
    // vert[1].color.a = 255;
// 
    // // right
    // vert[2].position.x = 600;
    // vert[2].position.y = 450;
    // vert[2].color.r = 0;
    // vert[2].color.g = 255;
    // vert[2].color.b = 0;
    // vert[2].color.a = 255;

    var quit = false;

    while(!quit)
    {
        var event: SDL.Event = undefined;

        while(SDL.PollEvent(&event))
        {
            switch(event.type)
            {
                c.SDL_QUIT => quit = true,
                c.SDLK_ESCAPE => quit = true,
                else => {},
            }

            if(event.type == c.SDL_KEYDOWN and event.key.keysym.sym == c.SDLK_ESCAPE) quit = true;
        }

        // const color = SDL.Color{ .r = 125, .g =45, .b=89, .a = 255 };
        try SDL.SetRenderDrawColor(renderer, .{ .r = 125, .g =45, .b=89, .a = 255 });
        try SDL.RenderClear(renderer);
        
        // SDL.RenderGeometry(renderer, null, vert, null);
        
        SDL.RenderPresent(renderer);
    }

    SDL.Quit();
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
