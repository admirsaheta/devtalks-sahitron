const std = @import("std");
const mem = std.mem;
const builtin = @import("builtin");
const is_windows = builtin.os.tag == .windows;


pub const Color = enum {
    reset,
    red,
    green,
    blue,
    cyan,
    purple,
    yellow,
    white,
};

pub fn fileSupportsColor(file: std.fs.File) bool {
    return file.supportsAnsiEscapeCodes() or (is_windows and file.isTty());
}

pub fn setColor(color: Color, w: anytype) void {
    _ = color;
  if (is_windows) {
    const stderr_file = std.io.getStdErr();
    if (!stderr_file.isTty()) return;
    const windows = std.os.windows;
    const S = struct {
        var attrs: windows.WORD = undefined;
        var init_attrs = false;
    };
    if (!S.init_attrs) {
        S.init_attrs = true;
        var info: windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
        _ = windows.kernel32.GetConsoleScreenBufferInfo(stderr_file.handle, &info);
        S.attrs = info.wAttributes;
        _ = windows.kernel32.SetConsoleOutputCP(65001);
    }

    // We need to flush the memory management here
    // because we are about to call a C function
    // that will allocate memory.
    const T = if (@typeInfo(@TypeOf(w.context)) == .Pointer) @TypeOf(w.context.*) else @TypeOf(w.context);
    if (T != void and @hasDecl(T,"flush")) w.context.flush() catch {};
  }
}