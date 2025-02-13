import Foundation

protocol SystemMonitorManaging {
    func startMonitoring(with: TimeInterval)
    func stopMonitoring()
}

