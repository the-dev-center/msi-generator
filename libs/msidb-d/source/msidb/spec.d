module msidb.spec;

import std.uuid;

/**
 * A tool-agnostic specification for Windows Installers (MSI/MSIX).
 * This decouples the what (files, registry, etc.) from the how (MSI tables, WiX XML, AppxManifest).
 */

struct ProductSpec {
    string name;
    string manufacturer;
    string productVersion;
    UUID productCode; // Used for MSI ProductCode
    UUID upgradeCode; // Used for MSI UpgradeCode
    
    FolderSpec rootFolder;
    ComponentSpec[] components;
    FeatureSpec[] features;
}

struct FolderSpec {
    string id;
    string name;
    string parentId;
    FolderSpec[] subfolders;
}

struct FileSpec {
    string id;
    string sourcePath;
    string targetName;
}

struct RegistrySpec {
    string id;
    enum Root { ClassesRoot, CurrentUser, LocalMachine, Users }
    Root root;
    string key;
    string name;
    string value;
}

struct ComponentSpec {
    string id;
    UUID guid;
    string directoryId;
    FileSpec[] files;
    RegistrySpec[] registryEntries;
}

struct FeatureSpec {
    string id;
    string title;
    string description;
    int level = 1;
    string[] componentIds;
}
