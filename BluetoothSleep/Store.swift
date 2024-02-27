import Foundation

struct Store {
    static let store = UserDefaults.standard
    
    static func saveSleepState(_ isSleeping: Bool) {
        store.set(isSleeping, forKey: "isSleeping")
    }

    static func loadSleepState() -> Bool {
        return store.bool(forKey: "isSleeping")
    }
    
    static func saveSleepDevices(_ macs: [BluetoothMac]) {
        store.set(macs.map{$0.mac}, forKey: "sleepDevices")
    }

    static func loadSleepDevices() -> [BluetoothMac] {
        return store.array(forKey: "sleepDevices")?.filter { $0 is String }.map {
            BluetoothMac($0 as! String)
        } ?? [];
    }
}
