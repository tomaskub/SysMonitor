import Foundation

struct DiskMetric {
    let total: UInt64
    let used: UInt64
    let free: UInt64

    var usagePercentage: Double {
        Double(used) / Double(total) * 100
    }
}
