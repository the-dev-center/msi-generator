module msigen.common;

struct PackageInfo {
    string name;
    string id;
    string pkgVersion;
    string publisher;
    string description;
    string executablePath;
}

interface PackageGenerator {
    void generate(PackageInfo info, string outputPath);
}
