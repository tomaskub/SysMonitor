protocol MetricCollecting {
    func collect() -> UsagePercentageable
}

protocol CpuMetricCollecting {
    func collect() -> Double
}

class CpuMetricCollector: CpuMetricCollecting {
    func collect() -> Double {
        .zero
    }
}
