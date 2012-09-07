module util.parser;

import std.file;
import std.string;
import std.stdio;
import std.traits;
import std.conv;
import std.regex;

import entity;
import ids;

auto regexNumber = regex(r"^[0-9\.]*$");
auto regexStatement = regex(r"\[([^\]]*)\]");

T stringToEnum(T)(string key, bool caseSensitive = false) {
    if(!caseSensitive) key = toLower(key);
    foreach(v, e; EnumMembers!T) {
        string type = to!string(e);

        if(!caseSensitive) type = toLower(type);
        if(type == key) return e;
    }

    assert(0, "No entry for " ~ key ~ " in " ~ T.stringof);
}

Id getId(string id) {
    try {
        return stringToEnum!Id(id);
    } catch(Error e) {
        throw new Exception("Unknown ID: " ~ id);
        return Id.UNKNOWN;
    }
}

class Argument {
    enum Type {
        String,
        Number,
        Id
    }

    this(string str) {
        this.type = Type.String;
        this.stringValue = str;
    }

    this(float num) {
        this.type = Type.Number;
        this.numberValue = num;
    }

    this(Id id) {
        this.type = Type.Id;
        this.idValue = id;
    }

    Type type;
    string stringValue;
    float numberValue;
    Id idValue;
}

class Parser {
    // callback when an unknown symbol is found
    // return a value for that id, otherwise
    // Id.Unkown

    // int delegate(string) unknownIdFound;


    Argument[][] statements;

    Argument[] peek() {
        if(statements.length > 0)
            return statements[0];
        return null;
    }

    Argument[] next() {
        auto r = peek();
        if(r !is null) {
            statements = statements[1..$];
        }
        return r;
    }

    this(string filename) {
        string file = readText(filename);        
        string[] lines = file.splitLines();

        foreach(line; lines) {
            line = line.strip();
            if(line == "") continue;
            if(line[0] != '[') continue;

            line = match(line, regexStatement).hit[1..$-1];
            statements ~= parseArguments(line);
        }

        parseAll();
    }

    void parseAll() {
        while(peek() !is null)
            parseLine();
    }

    void parseLine() {
        auto line = next();
        if(line[0].type == Argument.Type.Id && line[0].idValue == Id.DEFINE) {
            if(line.length > 2)
                parseDefine(line[1].idValue, line[2].idValue);
            else
                parseDefine(line[1].idValue, Id.UNKNOWN);
        }
    }

    void parseDefine(Id templateId, Id parentId) { 
        // TODO: parent template, if parentId != Id.UNKNOWN
        EntityTemplate tpl = new EntityTemplate;

        while(peek() !is null && peek()[0].idValue != Id.END) {
            parseComponent(tpl, next());
        }
        
        if(peek() is null)
            throw new Exception("Unexpected EOL.");

        // TODO: save the template
        writeln("Saving template");

        next(); // clear the end tag
    }

    void parseComponent(Entity e, Argument[] args) {
        // get the component with the associated id
        // set the arguments
        // add component to entity
    }

    Argument[] parseArguments(string line) {
        Argument[] result;

        auto splits = std.string.split(line, ":");
        foreach(split; splits) {
            split = split.strip();
            if(split[0] == '"') {
                if(split[$-1] != '"') 
                    throw new Exception("Unable to parse \"" ~ line ~ "\": invalid string delimiters");
                result ~= new Argument(split[1..$-1]);
            } else if(match(split, regexNumber)) {
                result ~= new Argument(to!float(split));
            } else {
                Id id = resolveId(split);
                if(id == Id.UNKNOWN) {
                    throw new Exception("Unable to parse \"" ~ line ~ "\": Unknown ID.");
                } else {
                    result ~= new Argument(id);
                }
            }
        }
        return result;
    }

    Id resolveId(string id) {
        if(id != id.toUpper()) {
            writeln("WARNING: IDs should be uppercase (" ~ id ~ ").");
        } 

        return getId(id);
    }
}
