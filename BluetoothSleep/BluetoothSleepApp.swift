import SwiftUI
import IOBluetooth

func disconnectAllSleepDevices() {
    Store.loadSleepDevices().forEach { mac in
        guard let device = IOBluetoothDevice(addressString: mac.mac) else {
            return
        }
        usleep(1000000)
        Bluetooth.disconnect(device)
    }
}

func registerSystemListeners() {
    let notificationCenter = NSWorkspace.shared.notificationCenter
    let queue = OperationQueue.main
    notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: queue) { note in
        print("Going to sleep")
        Store.saveSleepState(true)
        disconnectAllSleepDevices()
    }
    notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: queue) { note in
        print("Waking up")
        Store.saveSleepState(false)
    }
    let notifier = Notifier()
    IOBluetoothDevice.register(forConnectNotifications: notifier, selector: #selector(Notifier.connect))
}

@main
struct BluetoothSleepApp: App {
    
    init() {
        print("Starting")
        Store.saveSleepState(false)
        registerSystemListeners()
    }
    
    var body: some Scene {
        MenuBarExtra("BluetoothSleep", systemImage: "b.square") {
            ContentView()
        }.menuBarExtraStyle(.window)
        
        /*WindowGroup {
            ContentView()
        }*/
    }
    
    static func quit() {
        print("Quit")
        NSApplication.shared.terminate(nil)
    }
}
