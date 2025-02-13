import Foundation

final class SystemMonitorManager: @unchecked Sendable {
    private var metrics = [SystemMetric]()
    private var isRunning = false 

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

    private func collect() {}
}

