import Darwin

class MemMetricCollector: MemoryMetricCollecting {
    let pageSize = UInt64(vm_kernel_page_size)

    func collect() -> MemoryMetric {
        memUsage()
    }

    private func memUsage() -> MemoryMetric {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size) 

        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else {
            print("Error getting memory usage")
            return .zero
        }

        let free = UInt64(stats.free_count)
        let active = UInt64(stats.active_count)
        let inactive = UInt64(stats.inactive_count)
        let wired = UInt64(stats.wire_count)

        return MemoryMetric(
            total: [free, active, inactive, wired].reduce(0, +),
            used: active,
            free: free, 
            cached: wired)
    }
}
