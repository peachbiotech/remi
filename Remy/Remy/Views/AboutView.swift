//
//  SettingsView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        List {
            Section(header: Text("My Device")) {
                Label("Pairing", systemImage: "timer")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                HStack {
                    Label("Placeholder 2", systemImage: "clock")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Placeholder 3", systemImage: "paintpalette")
                }
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
