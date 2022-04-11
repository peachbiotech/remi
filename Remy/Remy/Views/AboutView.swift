//
//  SettingsView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct AboutView: View {
    
    @ObservedObject var bleManager: BLEManager
    
    var body: some View {
        List {
            Section(header: Text("My Device")) {
                switch bleManager.state {
                case .connected:
                    HStack {
                        NavigationLink(destination: MyDeviceDetailView(bleManager: bleManager)) {
                             HStack {
                                 Text(bleManager.connectedPeripheral?.name ?? "unknown device")
                                 Spacer()
                                 Text("Connected").foregroundColor(.gray)
                             }
                        }
                    }
                default:
                    NavigationLink(destination: PairingView(bleManager: bleManager)) {
                        Label("Pair Device", systemImage: "circle.grid.cross")
                    }
                }
            }
            Section() {
                NavigationLink(destination: LiveDebugView(bleManager: bleManager)) {
                    Text("Debug")
                }
                NavigationLink(destination: CreditView()) {
                     HStack {
                         Text("Acknowledgements")
                     }
                }
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AboutView(bleManager: BLEManager())
            }
            NavigationView {
                AboutView(bleManager: BLEManager())
            }
        }
    }
}
