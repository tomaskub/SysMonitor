import Foundation
import Termbox

final class SystemMonitorManager {
    private var metrics = [SystemMetric]() {
        didSet {
        }
    }
    private var isRunning = false 
    private var cpuMetricCollector: CpuMetricCollecting
    private var memMetricCollector: MemoryMetricCollecting
    private var diskMetricCollector: DiskMetricCollecting
    private var networkMetricCollector: NetworkMetricCollecting
    private var drawer: Drawing
    private var timer: Timer?

    init(
        cpuCollector: CpuMetricCollecting,
        memCollector: MemoryMetricCollecting,
        diskCollector: DiskMetricCollecting,
        networkCollector: NetworkMetricCollecting,
            drawing: Drawing
    ) {
        cpuMetricCollector = cpuCollector
        memMetricCollector = memCollector
        diskMetricCollector = diskCollector
        networkMetricCollector = networkCollector
        drawer = drawing
    }

    func startMonitoring(with interval: TimeInterval = 1.0) {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self,
                self.isRunning else { return }
            self.peekEvents()
            self.collect()
            self.drawer.draw(message: "Collected metric: cpu usage \(metrics.last?.cpuUsage ?? .zero) %")
        }

        RunLoop.current.run()
    }

    func stopMonitoring() {
        isRunning = false 
        timer?.invalidate()
        timer = nil
        exit(0)
    }

    private func peekEvents() {
        guard let event = Termbox.peekEvent(timoutInMilliseconds: 250) else { return }
        if case .character(_, let value) = event,
            value == "q" {
            stopMonitoring()
        }
    }
    private func collect() {
        let metrics = SystemMetric(
            timestamp: Date(),
            cpuUsage: cpuMetricCollector.collect(),
            memoryUsage: memMetricCollector.collect(),
            diskUsage: diskMetricCollector.collect(),
            networkUsage: networkMetricCollector.collect()
        )

        self.metrics.append(metrics)
    }

    // this seem to not work with termbox running
    private func setupExitHandler() {
        signal(SIGINT) { _ in
            print("\nExiting...")
            exit(0)
        }
    }
}

