import Foundation

final class SystemMonitorManager {
    private var metrics = [SystemMetric]() {
        didSet {
            print(
                """
                =====
                SysMetrics: 
                - CPU usage: \(metrics.last?.cpuUsage ?? .zero) %
                - Memory usage:  \(metrics.last?.memoryUsage.usagePercentage ?? .zero) %
                - Disk usage: 
                    - Writes: \(metrics.last?.diskUsage.writeBytes ?? .zero) bytes
                    - Reads: \(metrics.last?.diskUsage.readBytes ?? .zero) bytes
    """
            )
        }
    }
    private var isRunning = false 
    private var cpuMetricCollector: CpuMetricCollecting
    private var memMetricCollector: MemoryMetricCollecting
    private var diskMetricCollector: DiskMetricCollecting
    private var timer: Timer?

    init(
        cpuCollector: CpuMetricCollecting,
        memCollector: MemoryMetricCollecting,
        diskCollector: DiskMetricCollecting
    ) {
        cpuMetricCollector = cpuCollector
        memMetricCollector = memCollector
        diskMetricCollector = diskCollector
    }

    func startMonitoring(with interval: TimeInterval = 1.0) {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self,
                self.isRunning else { return }

            self.collect()
        }

        RunLoop.current.run()
    }

    func stopMonitoring() {
        isRunning = false 
        timer?.invalidate()
        timer = nil
        exit(0)
    }

    private func collect() {
        let metrics = SystemMetric(
            timestamp: Date(),
            cpuUsage: cpuMetricCollector.collect(),
            memoryUsage: memMetricCollector.collect(),
            diskUsage: diskMetricCollector.collect(),
            networkUsage: .zero
        )

        self.metrics.append(metrics)
    }

    private func setupExitHandler() {
        signal(SIGINT) { _ in
            print("\nExiting...")
            exit(0)
        }
    }
}

