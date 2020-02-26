// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "SimpleImageViewer",
    products: [
        .library(name: "SimpleImageViewer", targets: ["SimpleImageViewer"])
    ],
    targets: [
        .target(
            name: "SimpleImageViewer",
            path: "ImageViewer"
        )
    ]
)
