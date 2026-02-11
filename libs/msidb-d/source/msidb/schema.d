module msidb.schema;

/**
 * Windows Installer Table Definitions.
 */

struct Column {
    string name;
    enum Type { String, Int16, Int32 }
    Type type;
    bool isNullable;
    bool isPrimaryKey;
}

struct TableSchema {
    string name;
    Column[] columns;
}

immutable TableSchema FILE_TABLE = {
    name: "File",
    columns: [
        Column("File", Column.Type.String, false, true),
        Column("Component_", Column.Type.String, false, false),
        Column("FileName", Column.Type.String, false, false),
        Column("FileSize", Column.Type.Int32, false, false),
        Column("Version", Column.Type.String, true, false),
        Column("Language", Column.Type.String, true, false),
        Column("Attributes", Column.Type.Int16, true, false),
        Column("Sequence", Column.Type.Int32, false, false)
    ]
};

immutable TableSchema COMPONENT_TABLE = {
    name: "Component",
    columns: [
        Column("Component", Column.Type.String, false, true),
        Column("ComponentId", Column.Type.String, true, false),
        Column("Directory_", Column.Type.String, false, false),
        Column("Attributes", Column.Type.Int16, false, false),
        Column("Condition", Column.Type.String, true, false),
        Column("KeyPath", Column.Type.String, true, false)
    ]
};
