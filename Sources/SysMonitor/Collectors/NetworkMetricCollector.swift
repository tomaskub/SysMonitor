import Darwin

class NetworkMetricCollector: NetworkMetricCollecting {
    func collect() -> NetworkMetric {
        networkUsage()
    }

    private func networkUsage() -> NetworkMetric {
        var mib = [CTL_NET, PF_ROUTE, 0, 0, NET_RT_IFLIST2, 0]

        var len: size_t = 0
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0 else {
            return .zero
        }

        var buffer = [UInt8](repeating: 0, count: len)
        guard sysctl(&mib, 6, &buffer, &len, nil, 0) == 0 else {
            return .zero
        }

        var interfaces: [NetworkMetric] = []
        var offset = 0

        while offset < len {
            let data = buffer.dropFirst(offset)

            guard let msgPtr = data.withUnsafeBytes({ pointer in
                pointer.baseAddress?.assumingMemoryBound(to: if_msghdr.self)
            }) else {
                return .zero
            }

            if msgPtr.pointee.ifm_type == RTM_IFINFO2 {
                guard let ifmPtr = data.withUnsafeBytes({ pointer in
                    pointer.baseAddress?.assumingMemoryBound(to: if_msghdr2.self)
                }) else { return .zero }

                let namePtr = data.dropFirst(MemoryLayout<if_msghdr2>.size).withUnsafeBytes { ptr -> UnsafePointer<CChar>? in
                    ptr.baseAddress?.assumingMemoryBound(to: CChar.self)
                }

                let interfaceName = namePtr.map { String(cString: $0) } ?? "unknown"

                let metric = NetworkMetric(
                    name: interfaceName,
                    bytesReceived: UInt64(ifmPtr.pointee.ifm_data.ifi_ibytes),
                    bytesSent: UInt64(ifmPtr.pointee.ifm_data.ifi_obytes),
                    packetsReceived: UInt64(ifmPtr.pointee.ifm_data.ifi_ipackets),
                    packetsSent: UInt64(ifmPtr.pointee.ifm_data.ifi_opackets)
                )

                interfaces.append(metric)
            }

            offset += Int(msgPtr.pointee.ifm_msglen)
        }

        return interfaces.reduce(.zero, +) 
    }
}
