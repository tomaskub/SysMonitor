import Foundation

struct DiskMetric: UsagePercentageable {
    let total: UInt64
    let used: UInt64
    let free: UInt64
    let readBytes: Int64
    let writeBytes: Int64

    static var zero: DiskMetric {
        return DiskMetric(
            total: .zero, 
            used: .zero,
            free: .zero,
            readBytes: .zero,
            writeBytes: .zero
        )
    }
}

