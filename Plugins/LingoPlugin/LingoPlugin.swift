//
//  LingoPlugin.swift
//  LingoPlugin
//
//  MIT License
//
//  Copyright (c) 2022 Mobelux
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import PackagePlugin

enum Constants {
    static let outputDirectory = "GeneratedSources"
    static let outputFile = "Lingo.swift"
}

func lingoCommand(
    _ tool: PluginContext.Tool,
    input: Path,
    output: Path
) -> Command {
    let arguments: [String] = [
        "--input", input.string,
        "--output", output.string
    ]

    return .buildCommand(
        displayName: "Lingo",
        executable: tool.path,
        arguments: arguments,
        inputFiles: [input],
        outputFiles: [output]
    )
}

@main
struct LingoPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [Command] {
        guard
            let sourceTarget = target as? SourceModuleTarget,
            let inputFile = sourceTarget.sourceFiles(withSuffix: "strings")
                .map(\.path)
                .first else {
            return []
        }

        let outputFile = context.pluginWorkDirectory
            .appending([Constants.outputFile, Constants.outputFile])

        let lingo = try context.tool(named: "Lingo")
        return [lingoCommand(lingo, input: inputFile, output: outputFile)]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LingoPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        let inputFilePaths = target.inputFiles
            .filter { $0.type == .resource && $0.path.extension == "strings" }
            .map(\.path)

        guard let inputFile = inputFilePaths.first else {
            return []
        }

        let outputFile = context.pluginWorkDirectory
            .appending([Constants.outputDirectory, Constants.outputFile])

        let lingo = try context.tool(named: "Lingo")
        return [lingoCommand(lingo, input: inputFile, output: outputFile)]
    }
}
#endif
