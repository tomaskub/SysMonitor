protocol MetricCollecting {
    func collect() -> UsagePercentageable
}

protocol CpuMetricCollecting {
    func collect() -> Double
}

protocol MemoryMetricCollecting {
    func collect() -> MemoryMetric
}


protocol DiskMetricCollecting {
    func collect() -> DiskMetric
}
