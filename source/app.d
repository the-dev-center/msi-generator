import std.stdio;
import msigen.common;
import msigen.msix;
import msigen.msi;
import std.getopt;

void main(string[] args) {
    PackageInfo info;
    string type = "msix";
    string output;

    auto helpInformation = getopt(
        args,
        "name|n", "Name of the package", &info.name,
        "id|i", "Identity/AppID of the package", &info.id,
        "version|v", "Version (e.g. 1.0.0.0)", &info.version,
        "publisher|p", "Publisher string", &info.publisher,
        "desc|d", "Description", &info.description,
        "exe|e", "Path to executable", &info.executablePath,
        "type|t", "Package type (msi or msix)", &type,
        "output|o", "Output path", &output
    );

    if (helpInformation.helpWanted || output is null) {
        defaultGetoptPrinter("MSI/MSIX Generator", helpInformation.options);
        return;
    }

    PackageGenerator gen;
    if (type == "msix") {
        gen = new MsixGenerator();
    } else if (type == "msi") {
        gen = new MsiGenerator();
    } else {
        writeln("Unknown type: ", type);
        return;
    }

    gen.generate(info, output);
    writeln("Generated ", type, " package at ", output);
}
