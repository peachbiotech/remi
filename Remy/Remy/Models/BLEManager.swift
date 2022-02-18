//
//  BLEManager.swift
//  Remy
//
//  Created by Jia Chun Xie on 1/24/22.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable, Comparable, Equatable {
    // CBPeripheral wrapper struct
    static func < (lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.rssi < rhs.rssi
    }
    
    static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.peripheral.identifier == lhs.peripheral.identifier
    }
    
    let id: Int
    let name: String
    let rssi: Int
    let peripheral: CBPeripheral
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheral: CBPeripheral?
    
    // Service UUIDs
    private let heartRateO2ServiceUUID = CBUUID(string: "7ab13626-ddc3-4fa0-b724-06460cc40223")
    
    // Characteristic UUIDs
    // HEARTRATEO2_SERVICE
    private let heartRateMeasurementCharacteristicUUID = CBUUID(string: "179499e2-a77f-44e8-893a-3e05a904d0e2")
    private let o2MeasurementCharacteristicUUID = CBUUID(string: "3b040b83-161b-4a11-8ef8-6a869b06e1e9")
    
    private let serviceUUIDS: [CBUUID]
    
    private var heartRateMeasurementCharacteristic: CBCharacteristic?
    private var o2MeasurementCharacteristic: CBCharacteristic?
    
    var central: CBCentralManager!
    
    override init() {
        serviceUUIDS = [heartRateO2ServiceUUID]
        super.init()

        central = CBCentralManager(delegate: self, queue: nil)
        central.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    func connect(peripheral: CBPeripheral) {
        central.connect(peripheral, options: nil)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        central.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected to peripheral device")
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?.delegate = self
        self.stopScanning()
        // discoverServices will populate services and associated characteristics
        self.connectedPeripheral?.discoverServices(serviceUUIDS)
    }
     
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("could not connect to peripheral device")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("successfully disconnected from peripheral device")
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
       
        if peripheralName.contains("SleepTracker") {
            let newPeripheral = Peripheral(id: peripherals.count,
                                           name: peripheralName,
                                           rssi: RSSI.intValue,
                                           peripheral: didDiscover)
            print(newPeripheral)
            if !peripherals.contains(newPeripheral) {
                peripherals.append(newPeripheral)
            }
        }
    }
    
    func startScanning() {
         print("startScanning")
         central.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        central.stopScan()
    }
    
}

extension BLEManager: CBPeripheralDelegate {
    
    // Discover services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            if service.uuid == heartRateO2ServiceUUID {
                print("found heart rate o2 service")
                peripheral.discoverCharacteristics([heartRateMeasurementCharacteristicUUID,
                                                    o2MeasurementCharacteristicUUID], for: service)
            }
        }
    }
    
    // Discover characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            if characteristic.uuid == heartRateMeasurementCharacteristicUUID {
                print("found heart rate characteristic")
                heartRateMeasurementCharacteristic = characteristic
            }
            else if characteristic.uuid == o2MeasurementCharacteristicUUID {
                print("found o2 characteristic")
                o2MeasurementCharacteristic = characteristic
            }
        }
    }
    
    // Subscrible to BLE notifications
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("successfully subscribed to BLE notification")
    }
    
}
