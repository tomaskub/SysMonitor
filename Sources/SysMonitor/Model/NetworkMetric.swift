import Foundation

struct NetworkMetric {
    let name: String?
    let bytesReceived: UInt64
    let bytesSent: UInt64
    let packetsReceived: UInt64
    let packetsSent: UInt64

init(name: String? = nil, bytesReceived: UInt64, bytesSent: UInt64, packetsReceived: UInt64, packetsSent: UInt64) {
        self.name = name
        self.bytesReceived = bytesReceived
        self.bytesSent = bytesSent
        self.packetsReceived = packetsReceived
        self.packetsSent = packetsSent
    }
}

extension NetworkMetric: AdditiveArithmetic {
    static var zero: NetworkMetric {
        NetworkMetric(bytesReceived: .zero, bytesSent: .zero, packetsReceived: .zero, packetsSent: .zero)
    }

    static func +(lhs: NetworkMetric, rhs: NetworkMetric) -> NetworkMetric {
        return NetworkMetric(
            bytesReceived: lhs.bytesReceived + rhs.bytesReceived,
            bytesSent: lhs.bytesSent + rhs.bytesSent,
            packetsReceived: lhs.packetsReceived + rhs.packetsReceived,
            packetsSent: lhs.packetsSent + lhs.packetsSent
        )
    }

    static func -(lhs: NetworkMetric, rhs: NetworkMetric) -> NetworkMetric {
        return NetworkMetric(
            bytesReceived: lhs.bytesReceived.safeSubtract(rhs.bytesReceived),
            bytesSent: lhs.bytesSent.safeSubtract(rhs.bytesSent),
            packetsReceived: lhs.packetsReceived.safeSubtract(rhs.packetsReceived),
            packetsSent: lhs.packetsSent.safeSubtract(rhs.packetsSent)
        )
    }
}

extension UInt64 {
    func safeSubtract(_ subtrahend: UInt64) -> UInt64 {
        self >= subtrahend ? self - subtrahend : .zero
    }
}
