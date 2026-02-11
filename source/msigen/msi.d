module msigen.msi;

import msigen.common;
import std.stdio;

class MsiGenerator : PackageGenerator {
    void generate(PackageInfo info, string outputPath) {
        // MSI generation requires OLE Compound File (CFB) support and 
        // the MSI relational table structure.
        // Pure D implementation of CFB and MSI table injection is planned.
        writeln("MSI generation is currently a skeleton. MSIX is supported.");
    }
}
