import Foundation
import IOKit

class DiskMetricCollector: DiskMetricCollecting {
    private var totalReadBytes = Int64()
    private var totalWriteBytes = Int64()

    func collect() -> DiskMetric {
        collectIO()
    }

    private func collectIO() -> DiskMetric {
        let matching = IOServiceMatching("IOBlockStorageDriver")
        var iterator: io_iterator_t = 0

        guard IOServiceGetMatchingServices(
            kIOMasterPortDefault, matching, &iterator
        ) == KERN_SUCCESS else { 
            return .zero
        }

        var service = IOIteratorNext(iterator)
        while service != 0 {
            defer { IOObjectRelease(service) }

            if let stats = diskIOStats(for: service) {
                totalReadBytes += stats.0
                totalWriteBytes += stats.1
            }

            service = IOIteratorNext(iterator)
        }

        let usage = diskStorageStats()

        return .init(
            total: usage?.total ?? .zero,
            used: usage?.used ?? .zero,
            free: usage?.used ?? .zero,
            readBytes: totalReadBytes,
            writeBytes: totalWriteBytes
        )
    }

    private func diskIOStats(for service: io_service_t) -> (Int64, Int64)? {
        var proprerties: Unmanaged<CFMutableDictionary>?

        guard 
            IORegistryEntryCreateCFProperties(
                service,
                &proprerties,
                kCFAllocatorDefault,
                0
            ) == KERN_SUCCESS,
            let dict = proprerties?.takeRetainedValue() as? [String: Any],
            let stats = dict["Statistics"] as? [String: Any],
            let readBytes = stats["Bytes (Read)"] as? Int64,
            let writeBytes = stats["Bytes (Write)"] as? Int64 
            else {
            return nil 
        }

        return (readBytes, writeBytes)
    }

    private func diskStorageStats() -> (total: UInt64, used: UInt64, free: UInt64)? {
let url = URL(fileURLWithPath: "/")
        guard 
            let resourceValues = try? url.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey]),
            let totalSpace = resourceValues.volumeTotalCapacity,
            let avaliableSpace = resourceValues.volumeAvailableCapacity
            else {
            return nil
        }
        return (
            UInt64(totalSpace),
            UInt64(totalSpace - avaliableSpace),
            UInt64(avaliableSpace)
        )
    }
}
