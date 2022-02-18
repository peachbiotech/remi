//
//  SliderQuestionnaire.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/15/22.
//

import SwiftUI

struct LiveSessionView: View {
    
    @State var userSelectContinue: Int? = nil
    
    var body: some View {
        VStack {

        }
        .navigationTitle("Sweet Dreams")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.midNightBlue)
    }
}

struct LiveSessionView_Previews: PreviewProvider {
    static var previews: some View {
        LiveSessionView(
        )
    }
}
