import PackageDescription

let package = Package(
    name: "Sugar",
    targets: [
        Target(
            name: "Sugar",
            dependencies: []
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/ChameleonBot/Bot.git", majorVersion: 0, minor: 2)
    ],
    exclude: [
        "XcodeProject"
    ]
)
