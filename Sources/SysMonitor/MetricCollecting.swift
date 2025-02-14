protocol MetricCollecting {
    func collect() -> UsagePercentageable
}

protocol CpuMetricCollecting {
    func collect() -> Double
}

import Darwin

class CpuMetricCollector: CpuMetricCollecting {
    private var previousCPUTicks: host_cpu_load_info?

    func collect() -> Double {
        cpuUsage()
    }

    private func cpuUsage() -> Double {
        var cpuLoadInfo = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size) 

        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else {
            print("Error getting cpu usage")
            return .zero
        }

        let user = Double(cpuLoadInfo.cpu_ticks.0)
        let system = Double(cpuLoadInfo.cpu_ticks.1)
        let idle = Double(cpuLoadInfo.cpu_ticks.2)
        let nice = Double(cpuLoadInfo.cpu_ticks.3)

        guard let previousCPUTicks else {
            previousCPUTicks = cpuLoadInfo
            return .zero
        }

        // Diffs
        let userDiff = user - Double(previousCPUTicks.cpu_ticks.0)
        let systemDiff = system - Double(previousCPUTicks.cpu_ticks.1)
        let idleDiff  = idle - Double(previousCPUTicks.cpu_ticks.2)
        let niceDiff = nice - Double(previousCPUTicks.cpu_ticks.3)

        let total = userDiff + systemDiff + idleDiff + niceDiff
        let used = userDiff + systemDiff + niceDiff

        self.previousCPUTicks = cpuLoadInfo
        return (used / total) * 100.0
    }
}
