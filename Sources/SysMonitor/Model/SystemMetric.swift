import Foundation

struct SystemMetric {
    let timestamp: Date
    let cpuUsage: Double 
    let memoryUsage: MemoryMetric
    let diskUsage: DiskMetric
    let networkUsage: NetworkMetric

    static var zero: SystemMetric {
        SystemMetric(
            timestamp: Date(),
            cpuUsage: .zero,
            memoryUsage: .zero,
            diskUsage: .zero,
            networkUsage: .zero
        )
    }
}
