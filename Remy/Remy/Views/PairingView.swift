//
//  PairingView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//
import SwiftUI

struct PairingView: View {
    @ObservedObject var bleManager: BLEManager
    
    func shortListPeripherals(p: [Peripheral]) -> [Peripheral] {
        
        let namedPeripherals = p.filter { $0.name != "Unknown" }

        return namedPeripherals.sorted(by: >)
    }
    
    var body: some View {

        List {
            Section(header: BLEListHeader()) {
                if bleManager.isSwitchedOn {
                    if bleManager.peripherals.count != 0 {
                        ForEach (shortListPeripherals(p: bleManager.peripherals)) { peripheral in

                            HStack {
                                Text(peripheral.name)
                                Spacer()
                                Button("Connect") {
                                    self.bleManager.connect(peripheral: peripheral.peripheral)
                                    self.bleManager.setReadRate(rate: "500")
                                }.foregroundColor(.blue)
                            }
                        }
                    }
                    else {
                        Text("No devices detected").foregroundColor(.gray)
                    }
                }
                else {
                    Text("Please turn on Bluetooth")
                        .foregroundColor(.orange)
                }
            }
        }
                
            //.listRowBackground(ColorManager.spaceGrey)
        .listStyle(.insetGrouped)
        //.background(ColorManager.midNightBlue)
        .onAppear {
            //UITableView.appearance().backgroundColor = UIColor(ColorManager.midNightBlue)
            print("Pairing start")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.bleManager.startScanning()
            }
        }
        .onChange(of: bleManager.isSwitchedOn) { value in
            if bleManager.isSwitchedOn {
                self.bleManager.startScanning()
            }
        }
        .refreshable {
            self.bleManager.startScanning()
        }
        .navigationBarTitle("Pairing", displayMode: .inline)
    }
}

struct BLEListHeader: View {
    var body: some View {
        HStack {
            Text("Devices   ").foregroundColor(.gray)
            ProgressView()
        }
            
    }
}

struct PairingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PairingView(bleManager: BLEManager())
        }
    }
}
