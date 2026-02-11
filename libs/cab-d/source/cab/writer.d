module cab.writer;

import std.stdio;
import std.array;

/**
 * Basic Microsoft Cabinet (CAB) writer skeleton.
 * CAB format (MSCF) is required for MSI file storage.
 */
class CabWriter {
    struct FileEntry {
        string name;
        ubyte[] data;
    }
    
    private FileEntry[] files;
    
    void addFile(string name, ubyte[] data) {
        files ~= FileEntry(name, data);
    }
    
    void save(string path) {
        auto f = File(path, "wb");
        // header: MSCF...
        writeln("CAB Writer: Compressing ", files.length, " files into ", path, " (Skeleton)");
    }
}
