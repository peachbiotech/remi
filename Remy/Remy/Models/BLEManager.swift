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
    @Published var accelerometerData: (x: Float, y: Float, z: Float) = (0, 0, 0)
    @Published var gyroscopeData: (x: Float, y: Float, z: Float) = (0, 0, 0)
    
    @Published var hasEEG: Bool = true // Set to true for debug purposes
    @Published var hasHeart: Bool = true
    @Published var hasO2: Bool = true
    @Published var hasBattery: Bool = true
    @Published var hasImu: Bool = true
    
    @Published var isReady: Bool = true
    private var heartRateNotReadyCount: Int = 0
    private var o2NotReadyCount: Int = 0

    @Published var readRate: Int = 0
    
    // Service UUIDs
    private let heartRateO2ServiceUUID = CBUUID(string: "7ab13626-ddc3-4fa0-b724-06460cc40223")
    private let heartRateO2ReadRateServiceUUID = CBUUID(string: "71b55e6a-a938-432c-9304-b119b4f626d2")
    private let batteryServiceUUID = CBUUID(string: "d650e494-beac-45e5-ab00-d27ae4f9c603")
    //private let eegServiceUUID = CBUUID(string: "d650e494-beac-45e5-ab00-d27ae4f9c604")
    private let imuServiceUUID = CBUUID(string: "3b7a1639-8d9a-49e7-8077-67f398d95c2b")

    // Characteristic UUIDs
    // HEARTRATEO2_SERVICE
    private let heartRateMeasurementCharacteristicUUID = CBUUID(string: "179499e2-a77f-44e8-893a-3e05a904d0e2")
    private let o2MeasurementCharacteristicUUID = CBUUID(string: "3b040b83-161b-4a11-8ef8-6a869b06e1e9")
    // HEARTRATEO2_READ_RATE_SERVICE
    private let heartRateO2ReadRateCharacteristicUUID = CBUUID(string: "aba135ba-32a2-4190-a3d6-b26bdc8f123d")
    // BATTERY_SERVICE
    private let batteryLevelCharacteristicUUID = CBUUID(string: "64cb58e5-c7c6-4976-bfb2-8b0cb7527c22")
    private let batteryVoltageCharacteristicUUID = CBUUID(string: "8a1c6667-e658-4c43-9894-f6b119abb755")
    // EEG_SERVICE
    // IMU_SERVICE
    private let accelerometerCharacteristicUUID = CBUUID(string: "c89c6c9f-ef3e-4e78-84c6-8834566269b8")
    private let gyroscopeCharacteristicUUID = CBUUID(string: "4f6aaa29-8919-44bd-b21d-2950bb9e6922")
    private let temperatureCharacteristicUUID = CBUUID(string: "9d175382-ac47-4be4-8c60-24ec6024fc8d")
    
    private let serviceUUIDS: [CBUUID]
    
    private var heartRateMeasurementCharacteristic: CBCharacteristic?
    private var o2MeasurementCharacteristic: CBCharacteristic?
    private var heartRateO2ReadRateCharacteristic: CBCharacteristic?
    private var batteryLevelCharacteristic: CBCharacteristic?
    private var batteryVoltageCharacteristic: CBCharacteristic?
    private var accelerometerCharacteristic: CBCharacteristic?
    private var gyroscopeCharacteristic: CBCharacteristic?
    private var temperatureCharacteristic: CBCharacteristic?
    
    private let outOfRangeHeuristics: Set<CBError.Code> = [.unknown,
        .connectionTimeout, .peripheralDisconnected, .connectionFailed]
    
    var central: CBCentralManager!
    
    // State machine
    var state = State.poweredOff
    enum State {
        case poweredOff
        case restoringConnectingPeripheral(CBPeripheral)
        case restoringConnectedPeripheral(CBPeripheral)
        case disconnected
        case scanning(Countdown)
        case connecting(CBPeripheral, Countdown)
        case discoveringServices(CBPeripheral, Countdown)
        case discoveringCharacteristics(CBPeripheral, Countdown)
        case connected(CBPeripheral)
        case outOfRange(CBPeripheral)
        
        var peripheral: CBPeripheral? {
            switch self {
            case .poweredOff: return nil
            case .restoringConnectingPeripheral(let p): return p
            case .restoringConnectedPeripheral(let p): return p
            case .disconnected: return nil
            case .scanning: return nil
            case .connecting(let p, _): return p
            case .discoveringServices(let p, _): return p
            case .discoveringCharacteristics(let p, _): return p
            case .connected(let p): return p
            case .outOfRange(let p): return p
            }
        }
    }
    
    private let restoreIdKey = "RemyCentral"
    private let peripheralIdDefaultsKey = "RemyPeripheral"
    
    override init() {
        serviceUUIDS = [heartRateO2ServiceUUID, batteryServiceUUID, imuServiceUUID]
        super.init()
        
        let options = [CBCentralManagerOptionRestoreIdentifierKey: restoreIdKey]
        central = CBCentralManager(delegate: self, queue: nil, options: options)
        central.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
            switch self.state {
            case .poweredOff:
                // Firstly, try to reconnect:
                if let peripheralIdStr = UserDefaults.standard
                        .object(forKey: peripheralIdDefaultsKey) as? String,
                    let peripheralId = UUID(uuidString: peripheralIdStr),
                    let previouslyConnected = central
                        .retrievePeripherals(withIdentifiers: [peripheralId])
                        .first {
                    self.connect(peripheral: previouslyConnected)
                    
                    // Next, try for ones that are connected to the system:
                } else if let systemConnected = central
                        .retrieveConnectedPeripherals(withServices:
                        serviceUUIDS).first {
                    self.connect(peripheral: systemConnected)

                } else {
                    // Not an error, simply the case that they've never paired
                    // before, or they did a manual unpair:
                    self.state = .disconnected
                }
            // Did CoreBluetooth wake us up with a peripheral that was connecting?
            case .restoringConnectingPeripheral(let peripheral):
                self.connect(peripheral: peripheral)
            // CoreBluetooth woke us with a 'connected' peripheral, but we had
            //     to wait until 'poweredOn' state:
            case .restoringConnectedPeripheral(let peripheral):
                self.discoverServices(
                    peripheral: peripheral)
            default:
                break
            }
            
        }
        else {
            isSwitchedOn = false
            state = .poweredOff
        }
    }
    
    func connect(peripheral: CBPeripheral) {
        // Connect!
        // Note: We're retaining the peripheral in the state enum because Apple
        // says: "Pending attempts are cancelled automatically upon
        // deallocation of peripheral"
        central.connect(peripheral, options: nil)
        state = .connecting(peripheral, Countdown(seconds: 10, closure: {}))
    }
    
    func disconnect(forget: Bool = false) {
        
        if let peripheral = state.peripheral {
            central.cancelPeripheralConnection(peripheral)
        }
        if forget {
            UserDefaults.standard.removeObject(forKey: peripheralIdDefaultsKey)
            UserDefaults.standard.synchronize()
        }
        state = .disconnected
        self.o2Level = 0
        self.heartRate = 0
        self.batteryPercentage = 0
        self.eegQuality = .GOOD
        self.hasEEG = true
        self.hasHeart = false
        self.hasO2 = false
        self.hasBattery = false
        self.hasImu = false
        self.isReady = false
        self.readRate = 0
    }
    
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices(serviceUUIDS)
        state = .discoveringServices(peripheral, Countdown(seconds: 10, closure: {}))
    }
    
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            self.disconnect()
            return
        }
        state = .discoveringCharacteristics(peripheral, Countdown(seconds: 10, closure: {}))
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
            if service.uuid == imuServiceUUID {
                print("found imu service")
                peripheral.discoverCharacteristics([accelerometerCharacteristicUUID, gyroscopeCharacteristicUUID], for: service)
            }
        }
    }
    
    func setConnected(peripheral: CBPeripheral) {
       // Remember the ID for startup reconnecting.
       UserDefaults.standard.set(peripheral.identifier.uuidString,
           forKey: peripheralIdDefaultsKey)
       UserDefaults.standard.synchronize()
       
       state = .connected(peripheral)
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
    
    // Application restore delegate method
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
        let peripherals: [CBPeripheral] = dict[
            CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] ?? []
        if peripherals.count > 1 {
            print("Warning: willRestoreState called with >1 connection")
        }
        // We have a peripheral supplied, but we can't touch it until
        // `central.state == .poweredOn`, so we store it in the state
        // machine enum for later use.
        if let peripheral = peripherals.first {
            switch peripheral.state {
            case .connecting: // I've only seen this happen when
                // re-launching attached to Xcode.
                state =
                    .restoringConnectingPeripheral(peripheral)

            case .connected: // Store for connection / requesting
                // notifications when BT starts.
                state =
                    .restoringConnectedPeripheral(peripheral)
            default: break
            }
        }
        
        print("restored app")
    }
    
    // Successful connection to peripheral delegate method
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected to peripheral device")
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?.delegate = self
        self.stopScanning()
        // discoverServices will populate services and associated characteristics
        self.discoverServices(peripheral: peripheral)
    }
     
    // Failed to connect to peripheral delegate method
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("could not connect to peripheral device")
        state = .disconnected
    }
    
    // Disconnected from peripheral delegate method
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if state.peripheral?.identifier ==
                peripheral.identifier {
            // IME the error codes encountered are:
            // 0 = rebooting the peripheral.
            // 6 = out of range.
            if let error = error,
                (error as NSError).domain == CBErrorDomain,
                let code = CBError.Code(rawValue: (error as NSError).code),
                outOfRangeHeuristics.contains(code) {
                // Try reconnect without setting a timeout in the state machine.
                // With CB, it's like saying 'please reconnect me at any point
                // in the future if this peripheral comes back into range'.
                central.connect(peripheral, options: nil)
                state = .outOfRange(peripheral)
            } else {
                // Likely a deliberate unpairing.
                state = .disconnected
            }
        }
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
        guard central.state == .poweredOn else {
            print("Cannot scan, BT is not powered on")
            return
        }
        // Scan!
        central.scanForPeripherals(withServices: [heartRateO2ServiceUUID], options: nil)
        state = .scanning(Countdown(seconds: 10, closure: {
            self.central.stopScan()
            self.state = .disconnected
            print("Scan timed out")
        }))
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
        print("heartrate: \(self.heartRate)")
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

    func handleAccelerometerData(data: String) {
        let dataArray = data.components(separatedBy: "\t")
        if dataArray.count == 3 {
            let x = Float(dataArray[0]) ?? 0
            let y = Float(dataArray[1]) ?? 0
            let z = Float(dataArray[2]) ?? 0
            self.accelerometerData = (x, y, z)
            self.hasImu = true // TODO: Check imu ready
        }
    }

    func handleGyroscopeData(data: String) {
        let dataArray = data.components(separatedBy: "\t")
        if dataArray.count == 3 {
            let x = Float(dataArray[0]) ?? 0
            let y = Float(dataArray[1]) ?? 0
            let z = Float(dataArray[2]) ?? 0
            self.gyroscopeData = (x, y, z)
        }
    }

    func updateDeviceReady() {
        if !self.hasBattery {
            readBatteryVoltage(peripheral: self.connectedPeripheral!)
        }
        self.isReady = self.hasEEG && self.hasHeart && self.hasO2// TODO: calibrate battery && self.hasBattery
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
        // Ignore services discovered late.
        guard case .discoveringServices = state else {
            return
        }
        
        if let error = error {
            print("Failed to discover services: \(error)")
            disconnect()
            return
        }
        discoverCharacteristics(peripheral: peripheral)
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
            else if characteristic.uuid == accelerometerCharacteristicUUID {
                print("found accelerometer characteristic")
                accelerometerCharacteristic = characteristic
            }
            else if characteristic.uuid == gyroscopeCharacteristicUUID {
                print("found gyroscope characteristic")
                gyroscopeCharacteristic = characteristic
            }
        }
        
        setConnected(peripheral: peripheral)
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
        else if characteristic.uuid == accelerometerCharacteristicUUID {
            print("received accelerometer data")
            guard let accelerometerData = characteristic.value else {
                return
            }
            if let dataString = NSString.init(data: accelerometerData, encoding: String.Encoding.utf8.rawValue) as String? {
                handleAccelerometerData(data: dataString)
            }
        }
        else if characteristic.uuid == gyroscopeCharacteristicUUID {
            print("received gyroscope data")
            guard let gyroscopeData = characteristic.value else {
                return
            }
            if let dataString = NSString.init(data: gyroscopeData, encoding: String.Encoding.utf8.rawValue) as String? {
                handleGyroscopeData(data: dataString)
            }
        }
    }
    
}

/// Timer wrapper that automatically invalidates when released.
/// Read more: http://www.splinter.com.au/2019/03/28/timers-without-circular-references-with-pendulum
class Countdown {
    let timer: Timer
    
    init(seconds: TimeInterval, closure: @escaping () -> ()) {
        timer = Timer.scheduledTimer(withTimeInterval: seconds,
                repeats: false, block: { _ in
            closure()
        })
    }
    
    deinit {
        timer.invalidate()
    }
}
