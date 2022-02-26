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
    @Published var batteryPercentage: Int = 0
    
    @Published var hasEEG: Bool = true
    @Published var hasHeart: Bool = false
    @Published var hasO2: Bool = false
    @Published var hasBattery: Bool = true
    
    @Published var isReady: Bool = false
    private var heartRateNotReadyCount: Int = 0
    private var o2NotReadyCount: Int = 0

    @Published var readRate: Int = 0
    
    // Service UUIDs
    private let heartRateO2ServiceUUID = CBUUID(string: "7ab13626-ddc3-4fa0-b724-06460cc40223")
    private let heartRateO2ReadRateServiceUUID = CBUUID(string: "71b55e6a-a938-432c-9304-b119b4f626d2")
    private let batteryServiceUUID = CBUUID(string: "d650e494-beac-45e5-ab00-d27ae4f9c603")
    
    // Characteristic UUIDs
    // HEARTRATEO2_SERVICE
    private let heartRateMeasurementCharacteristicUUID = CBUUID(string: "179499e2-a77f-44e8-893a-3e05a904d0e2")
    private let o2MeasurementCharacteristicUUID = CBUUID(string: "3b040b83-161b-4a11-8ef8-6a869b06e1e9")
    // HEARTRATEO2_READ_RATE_SERVICE
    private let heartRateO2ReadRateCharacteristicUUID = CBUUID(string: "aba135ba-32a2-4190-a3d6-b26bdc8f123d")
    // BATTERY_SERVICE
    private let batteryLevelCharacteristicUUID = CBUUID(string: "64cb58e5-c7c6-4976-bfb2-8b0cb7527c22")
    private let batteryVoltageCharacteristicUUID = CBUUID(string: "8a1c6667-e658-4c43-9894-f6b119abb755")
    
    private let serviceUUIDS: [CBUUID]
    
    private var heartRateMeasurementCharacteristic: CBCharacteristic?
    private var o2MeasurementCharacteristic: CBCharacteristic?
    private var heartRateO2ReadRateCharacteristic: CBCharacteristic?
    private var batteryLevelCharacteristic: CBCharacteristic?
    private var batteryVoltageCharacteristic: CBCharacteristic?
    
    var central: CBCentralManager!
    
    override init() {
        serviceUUIDS = [heartRateO2ServiceUUID, batteryServiceUUID]
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
        self.batteryPercentage = 0
        self.eegQuality = .GOOD
        self.hasEEG = true
        self.hasHeart = false
        self.hasO2 = false
        self.hasBattery = false
        self.isReady = false
        self.readRate = 0
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
    
    func readBatteryVoltage(peripheral: CBPeripheral) {
        if let batteryVoltageCharacteristic = batteryVoltageCharacteristic {
            peripheral.readValue(for: batteryVoltageCharacteristic)
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
            heartRateNotReadyCount = 0
        }
        else {
            heartRateNotReadyCount += 1
            if (heartRateNotReadyCount >= 10) {
                self.heartRate = 0
                self.hasHeart = false
            }
        }
        updateDeviceReady()
    }

    // handle new oxygen measurement
    func handleO2Measurement(data: UInt8) {
        let temp = Int(data)
        if temp > 50 {
            self.o2Level = temp
            self.hasO2 = true
            o2NotReadyCount = 0
        }
        else {
            o2NotReadyCount += 1
            if (o2NotReadyCount >= 10) {
                self.o2Level = 0
                self.hasO2 = false
            }
        }
        updateDeviceReady()
    }
    
    // handle battery voltage read
    
    func handleBatteryVoltageRead(data: String) {
        let voltage = Float(data) ?? 0
        print("battery voltage: \(voltage)")
        let batteryVoltageMax = Float(4.0)
        let batteryVoltageMin = Float(3.2)
        
        var percentage = Int(100 * (voltage - batteryVoltageMin) / (batteryVoltageMax - batteryVoltageMin))
        print("battery 0: \((voltage - batteryVoltageMin))")
        percentage = min(max(percentage, 0), 100)
        if percentage > 0 {
            self.hasBattery = true
            self.batteryPercentage = percentage
        }
        print("battery percentage: \(self.batteryPercentage)")
    }

    func updateDeviceReady() {
        if !self.hasBattery {
            readBatteryVoltage(peripheral: self.connectedPeripheral!)
        }
        self.isReady = self.hasEEG && self.hasHeart && self.hasO2 && self.hasBattery
    }
    
    func getReadRate() {
        if (heartRateO2ReadRateCharacteristic != nil) && (self.connectedPeripheral != nil) {
            self.connectedPeripheral!.readValue(for: heartRateO2ReadRateCharacteristic!)
        }
    }

    func setReadRate(rate: String) {

        let data: Data? = rate.data(using: .utf8)
        
        if (heartRateO2ReadRateCharacteristic != nil) && (self.connectedPeripheral != nil) {
            self.connectedPeripheral!.writeValue(data!, for: heartRateO2ReadRateCharacteristic!, type: .withoutResponse)
        }
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
            if service.uuid == batteryServiceUUID {
                print("found battery service")
                peripheral.discoverCharacteristics([batteryLevelCharacteristicUUID,
                                                    batteryVoltageCharacteristicUUID], for: service)
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
            else if characteristic.uuid == heartRateO2ReadRateCharacteristicUUID {
                print("found read rate characteristic")
                heartRateO2ReadRateCharacteristic = characteristic
            }
            else if characteristic.uuid == batteryLevelCharacteristicUUID {
                batteryLevelCharacteristic = characteristic
            }
            else if characteristic.uuid == batteryVoltageCharacteristicUUID {
                print("found battery characteristic")
                batteryVoltageCharacteristic = characteristic
                self.readBatteryVoltage(peripheral: connectedPeripheral!)
            }
        }
    }
    
    // Subscrible to BLE notifications
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("successfully toggled BLE notification ")
    }

    // BLE value reads
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
        else if characteristic.uuid == heartRateO2ReadRateCharacteristicUUID {
            print("received current read rate")
            if let data = characteristic.value {
                print(data)
            }
        }
        else if characteristic.uuid == batteryLevelCharacteristicUUID {
            return
        }
        else if characteristic.uuid == batteryVoltageCharacteristicUUID {
            print("received battery voltage")
            
            guard let batteryVoltage = characteristic.value else {
                return
            }
            
            if let dataString = NSString.init(data: batteryVoltage, encoding: String.Encoding.utf8.rawValue) as String? {
                handleBatteryVoltageRead(data: dataString)
            }
        }
    }
    
}
