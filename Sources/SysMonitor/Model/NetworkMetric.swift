import Foundation

struct NetworkMetric {
    let bytesReceived: UInt64
    let bytesSent: UInt64
    let packetsReceived: UInt64
    let packetsSent: UInt64

    static var zero: NetworkMetric {
        NetworkMetric(bytesReceived: .zero, bytesSent: .zero, packetsReceived: .zero, packetsSent: .zero)
    }
}
