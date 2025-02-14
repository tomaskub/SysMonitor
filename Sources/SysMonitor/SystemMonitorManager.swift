import Foundation

final class SystemMonitorManager {
    private var metrics = [SystemMetric]() {
        didSet {
            print(
                """
                =====
                SysMetrics: 
                - CPU Usage: \(metrics.last?.cpuUsage ?? Double.zero)
    """
            )
        }
    }
    private var isRunning = false 
    private var cpuMetricCollector: CpuMetricCollecting
    private var timer: Timer?

    init(cpuCollector: CpuMetricCollecting) {
        cpuMetricCollector = cpuCollector
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
            memoryUsage:.zero,
            diskUsage: .zero,
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

