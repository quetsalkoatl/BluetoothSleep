import IOBluetooth

class Notifier {
    @objc func connect(notification: IOBluetoothUserNotification, device: IOBluetoothDevice) {
        print("Connected \(device.name ?? "Unknown")")
        if (Store.loadSleepState()) {
            print("System sleeping. Disconnecting")
            let mac = BluetoothMac(device.addressString)
            if Store.loadSleepDevices().contains(mac) {
                Bluetooth.disconnect(device)
            }
        }
    }
}
