// swift-tools-version: 5.5
import PackageDescription

// These are the unrar C++ files that are compiled directly.
// Files listed in the podspec as `preserve_paths` are intentionally omitted —
// they are #included by the source files above and must not be compiled separately.
let unrarSources: [String] = [
    "Libraries/unrar/rar.cpp",
    "Libraries/unrar/strlist.cpp",
    "Libraries/unrar/strfn.cpp",
    "Libraries/unrar/pathfn.cpp",
    "Libraries/unrar/smallfn.cpp",
    "Libraries/unrar/global.cpp",
    "Libraries/unrar/file.cpp",
    "Libraries/unrar/filefn.cpp",
    "Libraries/unrar/filcreat.cpp",
    "Libraries/unrar/archive.cpp",
    "Libraries/unrar/arcread.cpp",
    "Libraries/unrar/unicode.cpp",
    "Libraries/unrar/system.cpp",
    "Libraries/unrar/crypt.cpp",
    "Libraries/unrar/crc.cpp",
    "Libraries/unrar/rawread.cpp",
    "Libraries/unrar/encname.cpp",
    "Libraries/unrar/resource.cpp",
    "Libraries/unrar/match.cpp",
    "Libraries/unrar/timefn.cpp",
    "Libraries/unrar/rdwrfn.cpp",
    "Libraries/unrar/consio.cpp",
    "Libraries/unrar/options.cpp",
    "Libraries/unrar/errhnd.cpp",
    "Libraries/unrar/rarvm.cpp",
    "Libraries/unrar/secpassword.cpp",
    "Libraries/unrar/rijndael.cpp",
    "Libraries/unrar/getbits.cpp",
    "Libraries/unrar/sha1.cpp",
    "Libraries/unrar/sha256.cpp",
    "Libraries/unrar/blake2s.cpp",
    "Libraries/unrar/hash.cpp",
    "Libraries/unrar/extinfo.cpp",
    "Libraries/unrar/extract.cpp",
    "Libraries/unrar/volume.cpp",
    "Libraries/unrar/list.cpp",
    "Libraries/unrar/find.cpp",
    "Libraries/unrar/unpack.cpp",
    "Libraries/unrar/headers.cpp",
    "Libraries/unrar/threadpool.cpp",
    "Libraries/unrar/rs16.cpp",
    "Libraries/unrar/cmddata.cpp",
    "Libraries/unrar/ui.cpp",
    "Libraries/unrar/filestr.cpp",
    "Libraries/unrar/recvol.cpp",
    "Libraries/unrar/rs.cpp",
    "Libraries/unrar/scantree.cpp",
    "Libraries/unrar/qopen.cpp",
    "Libraries/unrar/dll.cpp",
]

let package = Package(
    name: "UnrarKit",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
    ],
    products: [
        .library(
            name: "UnrarKit",
            targets: ["UnrarKit"]
        ),
    ],
    targets: [
        .target(
            name: "UnrarKit",
            path: ".",
            exclude: [
                // Xcode-specific resources. The library looks for "UnrarKitResources.bundle"
                // at runtime, which doesn't match SPM's generated bundle naming. English error
                // strings are embedded as their own key text, so errors remain readable.
                "Resources",
                // Xcode example app and test target
                "Example",
                "Tests",
            ],
            sources: [
                "Classes/URKArchive.mm",
                "Classes/URKFileInfo.m",
                "Classes/Categories/NSString+UnrarKit.mm",
            ] + unrarSources,
            // SPMHeaders/ is a flat directory of symlinks to all public headers.
            // A flat layout is required because SPM rejects umbrella headers (UnrarKit.h)
            // when subdirectories exist alongside them (e.g. Categories/).
            // raros.hpp and dll.hpp are symlinked from Libraries/unrar/ so that
            // `#import <UnrarKit/raros.hpp>` resolves correctly for consumers.
            publicHeadersPath: "SPMHeaders",
            cSettings: [
                // SPMHeaders/UnrarKit/ is the flat public header directory.
                // Adding it here lets source files use unqualified imports like
                // `#import "UnrarKitMacros.h"` instead of `<UnrarKit/UnrarKitMacros.h>`.
                .headerSearchPath("SPMHeaders/UnrarKit"),
                .headerSearchPath("Libraries/unrar"),
            ],
            cxxSettings: [
                .headerSearchPath("SPMHeaders/UnrarKit"),
                .headerSearchPath("Libraries/unrar"),
                // Required by the unrar library:
                //   RARDLL  — compile as a callable library rather than standalone extractor
                //   SILENT  — suppress console output
                .define("RARDLL"),
                .define("SILENT"),
            ],
            linkerSettings: [
                .linkedLibrary("z"),
            ]
        ),
    ],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)
