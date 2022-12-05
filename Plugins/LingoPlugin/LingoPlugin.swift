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

@main
struct LingoPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        // ...

        let lingo = try context.tool(named: "lingo")
        var arguments: [String] = [
            // ...
        ]

        return [
            .buildCommand(
                displayName: "Lingo",
                executable: lingo.path,
                arguments: arguments,
                inputFiles: [],
                outputFiles: [context.pluginWorkDirectory]
            )
        ]
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
            .map(\.path)

        guard inputFilePaths.isEmpty == false else {
            return []
        }

        let lingo = try context.tool(named: "lingo")
        var arguments: [String] = [
            // ...
        ]

        // ...

        return [
            .buildCommand(
                displayName: "Lingo",
                executable: lingo.path,
                arguments: arguments,
                inputFiles: inputFilePaths,
                outputFiles: [context.pluginWorkDirectory]
            )
        ]
    }
}
#endif
