//
//  CreditView.swift
//  Remy
//
//  Created by Jia Chun Xie on 4/10/22.
//

import SwiftUI

struct CreditView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Acknowledgements").font(.title).bold().padding()

                Text("Peach Gang 🍑").font(.title2).bold().padding()
                Text("Boris Banovic\nHannah Helms\n Darrin Rountree\nAnanya Tandri\n Jason Xie\nMichelle Zheng").multilineTextAlignment(.center)
                
                Text("Advisors & Mentors 🤗").font(.title2).bold().padding()
                Text("Dr. Kenneth Donnelly\n Dr. Devin Hubbard\n Dr. Triffin Morris\n Dr. Naiquan Zheng\n Dr. Nathan Walker\n Dr. Robert Dennis").multilineTextAlignment(.center)
                Spacer()
                
                Text("Open Source 👩‍💻").font(.title2).bold().padding()
                Text("Arduino\n Sparkfun\nBackyard Brains\nAdafruit\n [SimpleChart](https://github.com/ImpostersLimited/SimpleChart) ").multilineTextAlignment(.center)
                
                Spacer()
                
            }.frame(maxWidth: .infinity)
        }

    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        CreditView()
    }
}
