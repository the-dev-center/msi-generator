module msigen.msix;

import msigen.common;
import std.zip;
import std.file;
import std.path;
import arsd.dom;
import std.format;

class MsixGenerator : PackageGenerator {
    void generate(PackageInfo info, string outputPath) {
        auto zip = new ZipArchive();
        
        // Add AppxManifest.xml
        auto manifest = createManifest(info);
        auto manifestEntry = new ArchiveMember();
        manifestEntry.name = "AppxManifest.xml";
        manifestEntry.expandedData = cast(ubyte[])manifest;
        zip.addMember(manifestEntry);
        
        // Add files (simplified - just the executable for now)
        if (info.executablePath.exists) {
            auto exeData = cast(ubyte[])read(info.executablePath);
            auto exeEntry = new ArchiveMember();
            exeEntry.name = info.executablePath.baseName;
            exeEntry.expandedData = exeData;
            zip.addMember(exeEntry);
        }
        
        // Write the zip file
        std.file.write(outputPath, zip.build());
    }

    private string createManifest(PackageInfo info) {
        return format!`<?xml version="1.0" encoding="utf-8"?>
<Package xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10" 
         xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10" 
         IgnorableNamespaces="uap">
  <Identity Name="%s" Version="%s" Publisher="%s" ProcessorArchitecture="x64" />
  <Properties>
    <DisplayName>%s</DisplayName>
    <PublisherDisplayName>%s</PublisherDisplayName>
    <Logo>Assets\StoreLogo.png</Logo>
  </Properties>
  <Resources>
    <Resource Language="en-us" />
  </Resources>
  <Applications>
    <Application Id="App" Executable="%s" EntryPoint="Windows.FullTrustApplication">
      <uap:VisualElements DisplayName="%s" Description="%s" 
                          BackgroundColor="#464646" Square150x150Logo="Assets\Square150x150Logo.png" 
                          Square44x44Logo="Assets\Square44x44Logo.png">
        <uap:DefaultTile Wide310x150Logo="Assets\Wide310x150Logo.png" />
      </uap:VisualElements>
    </Application>
  </Applications>
</Package>`(info.id, info.version, info.publisher, info.name, info.publisher, info.executablePath.baseName, info.name, info.description);
    }
}
