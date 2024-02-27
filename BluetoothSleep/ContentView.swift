import SwiftUI

struct ContentView: View {
    
    @State private var devices = Bluetooth.getDevices()
    
    func reload() {
        devices = Bluetooth.getDevices()
    }
    
    func setDeviceSleepDisconnect(_ device: BluetoothDevice, _ sleepDisconnect: Bool) {
        if let idx = devices.firstIndex(where: { $0.id == device.id }) {
            devices[idx].sleepDisconnect = sleepDisconnect
        }
        Store.saveSleepDevices(devices.filter { $0.sleepDisconnect }.map { $0.id })
    }
    
    var body: some View {
        VStack {
            Table(devices) {
                TableColumn("Name", value: \.name)
                TableColumn("Sleep disconnect") { device in
                    Toggle("", isOn: Binding<Bool>(
                        get: { return device.sleepDisconnect },
                        set: {
                            setDeviceSleepDisconnect(device, $0)
                        }
                    ))
                }.width(max: 100)
            }
            HStack {
                Button(action: reload) { Text("Reload") }
                Button(action: BluetoothSleepApp.quit) { Text("Quit") }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
