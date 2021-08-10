// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoList-API",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "ToDoList-API", targets: ["ToDoList-API"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from:"0.3.0")),
        .package(url: "https://github.com/soto-project/soto.git", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "ToDoList-API",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "SotoDynamoDB", package: "soto"),
            ],
            resources: [
                .process("Config.plist")
            ]
        ),
    ]
)
