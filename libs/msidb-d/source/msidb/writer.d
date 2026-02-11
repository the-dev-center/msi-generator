module msidb.writer;

import msidb.spec;
// import cfb;
// import cab;

/**
 * Maps ProductSpec to MSI Tables.
 */
class MsiDatabase {
    private ProductSpec productSpec;
    
    this(ProductSpec spec) {
        this.productSpec = spec;
    }
    
    void save(string path) {
        // 1. Generate Tables (File, Component, Directory, Feature, etc.)
        // 2. Generate Strings Pool
        // 3. Create OLE2 Compound File (CFB)
        // 4. Write tables as streams
        // 5. Generate and embed Cabinet files
    }
}
