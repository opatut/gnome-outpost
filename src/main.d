import std.stdio;
import luad.all;

int main() {

    LuaState lua = new LuaState;
    lua.openLibs();
    lua.doString("print('lol')");
    return 0;
}
