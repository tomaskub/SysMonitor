import Foundation

struct MemoryMetric: UsagePercentageable {
    let total: UInt64
    let used: UInt64
    let free: UInt64
    let cached: UInt64
}
