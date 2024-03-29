# Lingo

Lingo adds statically typed localized strings, which enables fast and less error prone user visible string entry.

## Installation

### 📦 Swift Package Manager (recommended)

Use SPM for best overall result for both local development and CI environments.

Add `Lingo` to your `Packages.swift` file:

```
.package(url: "https://github.com/Mobelux/Lingo", from: "1.0.0"),
```

Add a `Run Script` build phase to your Xcode project and include the following script:

```
INPUT="./<app-name>/Resources/Localizable.strings"
OUTPUT="./<app-name>/Utils/Lingo.swift"

if which .build/release/lingo >/dev/null; then
.build/release/lingo --input $INPUT --output $OUTPUT
else
swift run -c release lingo --input $INPUT --output $OUTPUT
fi
```

### 🌱 Mint

`mint install Mobelux/Lingo`

Add a `Run Script` build phase to your Xcode project and include the following script:

```
INPUT="./<app-name>/Resources/Localizable.strings"
OUTPUT="./<app-name>/Utils/Lingo.swift"

lingo --input $INPUT --output $OUTPUT
```

### ⚙️ Manual

Clone this repo and build the executable:

`swift build -c release lingo`

Copy the resulting binary to a location where it can be executed. It is recommeded to add it to the project directory and include in SCM for best result on CI.

Add a `Run Script` build phase to your Xcode project and include the following script:

```
INPUT="./<app-name>/Resources/Localizable.strings"
OUTPUT="./<app-name>/Utils/Lingo.swift"

<path-to-lingo>/lingo --input $INPUT --output $OUTPUT
```

## Usage

Add a `Localizable.strings` file to your project, for most configurations this is your `--input` file. The first time Lingo is executed it will create a Swift source file at the location specified in `--output`. Add this file to your Xcode project. Subsequent executions will update this file, adding new localized strings.

### Plugin Support

Lingo can be used as a build tool plugin for Xcode projects or Swift packages. It does not require any configuration when used as a plugin.

#### Xcode

Add Lingo as a package dependency to your project without linking any of the products.

Open the `Build Phases` inspector for the desired target, expand the `Run Build Tool Plug-ins` section, and select the `+` button. Select `LingoPlugin` from the list and add it to the project.

#### Swift Package

After adding `Lingo` as a package dependency in `Package.swift`, add `LingoPlugin` to a target using the `plugins` parameter:

```
targets: [
    .target(
        ...
        plugins: [
            .plugin(name: "LingoPlugin", package: "Lingo")
        ]
    )
]
```
