import Foundation

final class SystemMonitorManager {
    private var metrics = [SystemMetric]()
    private var isRunning = false 
    private var cpuMetricCollector: MetricCollecting?
    private var memoryMetricCollector: MetricCollecting?
    private var diskMetricCollector: MetricCollecting?
    private var networkMetricCollector: MetricCollecting?

    init() {}

    func startMonitoring(with interval: TimeInterval = 1.0) {
        isRunning = true
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self,
                self.isRunning else { return }

            self.collect()
        }
    }

    func stopMonitoring() {}

    private func collect() {
        let metrics = SystemMetric(
            timestamp: Date(),
            cpuUsage: 0.0,
            memoryUsage: memoryMetricCollector?.collect() as! MemoryMetric,
            diskUsage: diskMetricCollector?.collect() as! DiskMetric,
            networkUsage: networkMetricCollector?.collect() as! NetworkMetric
        )

        self.metrics.append(metrics)
    }
}

