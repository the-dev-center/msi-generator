import std.stdio;
import std.getopt;
import std.file : readText;
import asdf;

import msidb.spec;
import msidb.writer;
import msigen.common;
import msigen.msix;
import msigen.msi;

void main(string[] args) {
    PackageInfo info;
    string type = "msix";
    string output;
    string specPath;

    auto helpInformation = getopt(
        args,
        "name|n", "Name of the package", &info.name,
        "id|i", "Identity/AppID of the package", &info.id,
        "version|v", "Version (e.g. 1.0.0.0)", &info.pkgVersion,
        "publisher|p", "Publisher string", &info.publisher,
        "desc|d", "Description", &info.description,
        "exe|e", "Path to executable", &info.executablePath,
        "type|t", "Package type (msi or msix)", &type,
        "output|o", "Output path", &output,
        "spec|s", "Path to JSON specification file", &specPath
    );

    if (helpInformation.helpWanted || (output is null && specPath is null)) {
        defaultGetoptPrinter("MSI/MSIX Generator", helpInformation.options);
        return;
    }

    if (specPath !is null) {
        auto specText = readText(specPath);
        ProductSpec productSpec;
        try {
            productSpec = specText.deserialize!ProductSpec;
        } catch (Exception e) {
            writeln("Error parsing spec: ", e.msg);
            writeln("Spec content: ", specText);
            return;
        }
        
        if (type == "msi") {
            auto db = new MsiDatabase(productSpec);
            db.save(output);
        } else {
            PackageInfo pinfo;
            pinfo.name = productSpec.name;
            pinfo.pkgVersion = productSpec.productVersion;
            pinfo.publisher = productSpec.manufacturer;
            
            import std.conv : to;
            pinfo.id = productSpec.productCode.to!string;
            
            // Find executable path from components
            import std.algorithm : endsWith;
            foreach (comp; productSpec.components) {
                foreach (file; comp.files) {
                    if (file.sourcePath.endsWith(".exe")) {
                        pinfo.executablePath = file.sourcePath;
                        break;
                    }
                }
                if (pinfo.executablePath.length > 0) break;
            }

            if (pinfo.executablePath.length == 0) {
                writeln("Warning: No executable found in spec components. MSIX might be invalid.");
            }

            auto gen = new MsixGenerator();
            gen.generate(pinfo, output);
        }
        writeln("Generated ", type, " package at ", output);
        return;
    }

    PackageGenerator gen;
    if (type == "msix") {
        gen = new MsixGenerator();
    } else if (type == "msi") {
        writeln("MSI generation via CLI flags is limited. Use --spec.");
        return;
    } else {
        writeln("Unknown type: ", type);
        return;
    }

    gen.generate(info, output);
    writeln("Generated ", type, " package at ", output);
}
