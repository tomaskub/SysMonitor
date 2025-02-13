protocol UsagePercentageable {
    var total: UInt64 { get }
    var used: UInt64 { get }
    var usagePercentage: Double { get }
}

extension UsagePercentageable {
    var usagePercentage: Double {
        Double(used) / Double(total) * 100
    }
}

protocol Metric {}
