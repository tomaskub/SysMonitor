// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Swinject

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

    func run() throws {
        let container = Self.resolveContainer()
        let monitor = container.resolve(SystemMonitorManager.self)
        guard let monitor else {
            throw RuntimeError.failedToResolve
        }
        monitor.startMonitoring()
    }

    static func resolveContainer() -> Container {
        let container = Container()

        container.register(CpuMetricCollector.self) { _ in
            CpuMetricCollector()
        }

        container.register(MemMetricCollector.self) { _ in
            MemMetricCollector()
        }

        container.register(SystemMonitorManager.self) { resolver in
            SystemMonitorManager(
                cpuCollector: resolver.resolve(CpuMetricCollector.self)!,
                memCollector: resolver.resolve(MemMetricCollector.self)!
            )
        }

        return container
    }

    enum RuntimeError: Error {
        case failedToResolve
    }
} 
