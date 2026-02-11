# Static Build Script for msi-generator
# Requires LDC (LLVM D Compiler)

echo "Building msi-generator (static)..."

# Configuration for static linking
LDC_FLAGS="-static -linker=gold -L--no-as-needed -L-lpthread -L-lm -O3 -release"

dub build --compiler=ldc2 --config=executable --build=release --build-mode=allAtOnce --combined-flags="$LDC_FLAGS"

echo "Build complete."
ls -lh msi-generator*
