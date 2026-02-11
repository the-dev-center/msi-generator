module cfb.writer;

import std.stdio;
import std.array;
import std.system : Endian;
import std.bitmanip;

/**
 * Basic OLE2 Compound File Binary (CFB) writer.
 */
class CfbWriter {
    struct Entry {
        string name;
        ubyte[] data;
    }

    private Entry[] entries;

    void addStream(string name, ubyte[] data) {
        entries ~= Entry(name, data);
    }

    void save(string path) {
        auto f = File(path, "wb");
        
        // Header
        ubyte[512] header;
        header[0..8] = [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1]; // Magic
        
        header[24..26] = nativeToLittleEndian(cast(ushort)0x003E); // Minor version
        header[26..28] = nativeToLittleEndian(cast(ushort)0x0003); // Major version (v3)
        header[28..30] = nativeToLittleEndian(cast(ushort)0xFFFE); // Byte order
        header[30..32] = nativeToLittleEndian(cast(ushort)9);      // Sector shift
        header[32..34] = nativeToLittleEndian(cast(ushort)6);      // Mini sector shift
        
        f.rawWrite(header);
        
        writeln("CFB Writer: Writing ", entries.length, " streams (Skeleton)");
    }
}
