//
//  PairingView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//
import SwiftUI

struct PairingView: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var isRecording: Bool
    
    func shortListPeripherals(p: [Peripheral]) -> [Peripheral] {
        
        let namedPeripherals = p.filter { $0.name != "Unknown" }

        return namedPeripherals.sorted(by: >)
    }
    
    var body: some View {
        VStack {
            Text("Bedtime")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.bottom], 100)
                .foregroundColor(.white)
            HStack {
                Text("Discovering your sleep tracker   ").foregroundColor(.white).font(.headline)
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }

            List {
                Section(header: BLEListHeader()) {
                    if bleManager.isSwitchedOn {
                        if bleManager.peripherals.count != 0 {
                            ForEach (shortListPeripherals(p: bleManager.peripherals)) { peripheral in
                                NavigationLink(destination: PairedInfoView(bleManager: bleManager, isRecording: $isRecording).onAppear(perform: {
                                    print("connect")
                                    self.bleManager.connect(peripheral: peripheral.peripheral)
                                    self.bleManager.setReadRate(rate: "500")
                                    })
                                ) {
                                    HStack {
                                        Text(peripheral.name).font(.headline)
                                        Spacer()
                                        Text("Connect")
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
                .listRowBackground(ColorManager.spaceGrey)
            }
            .listStyle(.insetGrouped)
            .padding()
        }
        .background(ColorManager.midNightBlue)
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(ColorManager.midNightBlue)
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
    }
}

struct BLEListHeader: View {
    var body: some View {
        Text("Devices").foregroundColor(.gray)
    }
}

struct PairingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PairingView(bleManager: BLEManager(), isRecording: .constant(false))
        }
    }
}
