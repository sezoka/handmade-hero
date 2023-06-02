const std = @import("std");
const sdl = @import("sdl.zig");

fn handle_event(event: *sdl.SDL_Event) bool {
    var should_quit = false;

    switch (event.type) {
        sdl.SDL_QUIT => {
            std.debug.print("SDL_QUIT\n", .{});
            should_quit = true;
        },
        sdl.SDL_WINDOWEVENT => {
            switch (event.window.event) {
                sdl.SDL_WINDOWEVENT_RESIZED => {
                    std.debug.print("SDL_WINDOWEVENT_RESIZED {d} {d}\n", .{ event.window.data1, event.window.data2 });
                    is_white = !is_white;
                },
                else => {},
            }
        },
        else => {},
    }

    return should_quit;
}

var is_white = false;

pub fn main() !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        sdl.SDL_Log("Unable to initialize SDL: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer sdl.SDL_Quit();

    const window = sdl.SDL_CreateWindow(
        "Handmade Hero",
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        640,
        480,
        sdl.SDL_WINDOW_RESIZABLE,
    ) orelse {
        sdl.SDL_Log("Unable to create window: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer sdl.SDL_DestroyWindow(window);

    const renderer = sdl.SDL_CreateRenderer(window, -1, 0);
    defer sdl.SDL_DestroyRenderer(renderer);

    while (true) {
        var event: sdl.SDL_Event = undefined;
        _ = sdl.SDL_WaitEvent(&event);
        if (handle_event(&event)) {
            break;
        }

        _ = sdl.SDL_RenderClear(renderer);

        if (is_white) {
            _ = sdl.SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        } else {
            _ = sdl.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        }

        _ = sdl.SDL_RenderPresent(renderer);
    }
}
