import Foundation

struct DiskMetric: UsagePercentageable {
    let total: UInt64
    let used: UInt64
    let free: UInt64
}
