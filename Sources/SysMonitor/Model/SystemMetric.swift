import Foundation

struct SystemMetric {
    let timestamp: Date
    let cpuUsage: Double 
    let memoryUsage: MemoryMetric
    let diskUsage: DiskMetric
    let networkUsage: NetworkMetric
}
