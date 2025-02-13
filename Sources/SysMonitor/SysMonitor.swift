// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct SysMonitor: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sysmon",
        abstract: "A system resource monitoring tool"
    )

    @Flag(name: .shortAndLong, help: "Show CPU usage")
    var cpu = false 

    @Flag(name: .shortAndLong, help: "Show memory usage")
    var memory = false 

    static func run() throws {
        let monitor = SystemMonitorManager()
        monitor.startMonitoring()
    }
}
