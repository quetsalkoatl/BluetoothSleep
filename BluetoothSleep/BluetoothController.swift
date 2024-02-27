import IOBluetooth

class BluetoothController {
    
    func getDevices() {
        IOBluetoothDevice.pairedDevices().forEach { device in
            guard let device = device as? IOBluetoothDevice,
                          let addressString = device.addressString,
                          let deviceName = device.name
                    else { return }
                    
                    let connected = device.isConnected()
    }
}
