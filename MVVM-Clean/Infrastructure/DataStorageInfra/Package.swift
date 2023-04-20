// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataStorageInfra",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "DataStorageInfra",
            targets: ["DataStorageInfra"]),
    ],
    dependencies: [
       
    ],
    targets: [        
        .target(
            name: "DataStorageInfra",
            dependencies: [],
            path:"Resources")

    ]
)
