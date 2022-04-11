//
//  MyDeviceDetailView.swift
//  Remy
//
//  Created by Jia Chun Xie on 4/10/22.
//

import SwiftUI

struct MyDeviceDetailView: View {
    
    @ObservedObject var bleManager: BLEManager
    @State private var showConfirmation = false
    var deviceName: String {
        return bleManager.connectedPeripheral?.name ?? "Unknown Device"
    }
    
    var body: some View {
        List {
            Section(header: Text("About")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(deviceName).foregroundColor(.gray)
                }
                HStack {
                    Text("Model Number")
                    Spacer()
                    Text("P69420").foregroundColor(.gray)
                }
                HStack {
                    Text("Serial Number")
                    Spacer()
                    Text("L0R3M3P$UM").foregroundColor(.gray)
                }
            }
            Section() {
                Button("Forget This Device") {
                    showConfirmation = true
                }.confirmationDialog("Disconnect confirm", isPresented: $showConfirmation, titleVisibility: .hidden) {
                    Button("Forget Device", role: .destructive) {
                        bleManager.disconnect(forget: true)
                    }
                }
            }
        }.navigationBarTitle(deviceName, displayMode: .inline)
    }
}

struct MyDeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyDeviceDetailView(bleManager: BLEManager())
    }
}
