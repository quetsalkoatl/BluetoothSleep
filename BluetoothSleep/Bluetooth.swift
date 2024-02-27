import IOBluetooth

struct BluetoothMac: Hashable {
    let mac: String
    
    init(_ mac: String) {
        self.mac = mac
    }
    
    static func == (lhs: BluetoothMac, rhs: BluetoothMac) -> Bool {
        lhs.mac == rhs.mac
    }
}

struct BluetoothDevice: Identifiable {
    let id: BluetoothMac
    let name: String
    var sleepDisconnect: Bool
}

struct Bluetooth {
    static func getDevices() -> [BluetoothDevice] {
        let saved = Store.loadSleepDevices()
        return IOBluetoothDevice.pairedDevices().filter { $0 is IOBluetoothDevice }.map {
            let device = $0 as! IOBluetoothDevice
            let id = BluetoothMac( device.addressString)
            return BluetoothDevice(id: id, name: device.name, sleepDisconnect: saved.contains(id))
        }
    }
    
    static func disconnect(_ device: IOBluetoothDevice) {
        print("Disconnecting \(device.name ?? "Unknown")")
        if (!device.isPaired()) {
            return
        }
        // Source : https://github.com/lapfelix/BluetoothConnector/blob/e14caa151983964cea3f2cb4382d9150813bbe73/Sources/BluetoothConnector/main.swift#L102
        var attempts = 0
        while (attempts < 10 && device.isConnected()) {
            device.closeConnection()
            usleep(500000)
            attempts += 1
        }
    }
}
