import Foundation

final class SystemMonitorManager {
    private var metrics = [SystemMetric]()
    private var isRunning = false 
    private var cpuMetricCollector: CpuMetricCollecting

    init(cpuCollector: CpuMetricCollecting) {
        cpuMetricCollector = cpuCollector
    }

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
            cpuUsage: cpuMetricCollector.collect(),
            memoryUsage:.zero,
            diskUsage: .zero,
            networkUsage: .zero
        )

        self.metrics.append(metrics)
    }
}

