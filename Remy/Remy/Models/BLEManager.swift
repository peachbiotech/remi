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

    @Published var eegQuality: EEGQuality = EEGQuality.GOOD
    @Published var heartRate = 0
    @Published var o2Level = 0
    @Published var batteryLevel: Int = 65
    
    @Published var hasEEG: Bool = true
    @Published var hasHeart: Bool = false
    @Published var hasO2: Bool = false
    @Published var hasBattery: Bool = true
    
    @Published var isReady: Bool = false
    
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
        self.o2Level = 0
        self.heartRate = 0
        self.batteryLevel = 0
        self.eegQuality = .GOOD
        self.hasEEG = true
        self.hasHeart = false
        self.hasO2 = false
        self.hasBattery = false
        self.isReady = false

    }

    // Subscribe to heart rate measurement characteristic
    func subscribeToHeartRateMeasurementCharacteristic(peripheral: CBPeripheral) {
        if let heartRateMeasurementCharacteristic = heartRateMeasurementCharacteristic {
            peripheral.setNotifyValue(true, for: heartRateMeasurementCharacteristic)
        }
    }

    // Subscribe to oxygen measurement characteristic
    func subscribeToO2MeasurementCharacteristic(peripheral: CBPeripheral) {
        if let o2MeasurementCharacteristic = o2MeasurementCharacteristic {
            peripheral.setNotifyValue(true, for: o2MeasurementCharacteristic)
        }
    }

    // Unsubscribe to heart rate measurement characteristic
    func unsubscribeToHeartRateMeasurementCharacteristic(peripheral: CBPeripheral) {
        if let heartRateMeasurementCharacteristic = heartRateMeasurementCharacteristic {
            peripheral.setNotifyValue(false, for: heartRateMeasurementCharacteristic)
        }
    }

    // Unsubscribe to oxygen measurement characteristic
    func unsubscribeToO2MeasurementCharacteristic(peripheral: CBPeripheral) {
        if let o2MeasurementCharacteristic = o2MeasurementCharacteristic {
            peripheral.setNotifyValue(false, for: o2MeasurementCharacteristic)
        }
    }
    
    // Successful connection to peripheral delegate method
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected to peripheral device")
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?.delegate = self
        self.stopScanning()
        // discoverServices will populate services and associated characteristics
        self.connectedPeripheral?.discoverServices(serviceUUIDS)
    }
     
    // Failed to connect to peripheral delegate method
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("could not connect to peripheral device")
    }
    
    // Disconnected from peripheral delegate method
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("successfully disconnected from peripheral device")
    }
    
    // Discovered a peripheral delegate method
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
    
    // Scan for peripherals
    func startScanning() {
         print("startScanning")
         central.scanForPeripherals(withServices: nil, options: nil)
     }
    
    // Stop scanning for peripherals
    func stopScanning() {
        print("stopScanning")
        central.stopScan()
    }

    // Handle new heart rate measurement
    func handleHeartRateMeasurement(data: UInt8) {
        let temp = Int(data)
        if temp > 0 {
            self.heartRate = temp
            self.hasHeart = true
        }
        else {
            self.heartRate = 0
            self.hasHeart = false
        }
        updateDeviceReady()
    }

    // handle new oxygen measurement
    func handleO2Measurement(data: UInt8) {
        let temp = Int(data)
        if temp > 50 {
            self.o2Level = temp
            self.hasO2 = true
        }
        else {
            self.o2Level = 0
            self.hasO2 = false
        }
        updateDeviceReady()
    }

    func updateDeviceReady() {
        self.isReady = self.hasEEG && self.hasHeart && self.hasO2 && self.hasBattery
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
                peripheral.setNotifyValue(true, for: characteristic)
            }
            else if characteristic.uuid == o2MeasurementCharacteristicUUID {
                print("found o2 characteristic")
                o2MeasurementCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // Subscrible to BLE notifications
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("successfully toggled BLE notification ")
    }

    // Receive BLE notifications
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == heartRateMeasurementCharacteristicUUID {
            print("received heart rate measurement")
            if let data = characteristic.value {
                handleHeartRateMeasurement(data: data[0])
            }
        }
        else if characteristic.uuid == o2MeasurementCharacteristicUUID {
            print("received o2 measurement")
            if let data = characteristic.value {
                handleO2Measurement(data: data[0])
            }
        }
    }
    
}
