//
//  PreSleepQuestionnaireView.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/15/22.
//

import SwiftUI

struct PreSleepQuestionnaireView: View {
    
    @State var userSelectContinue: Int? = nil
    
    var body: some View {
        VStack {
            Text("Recap your day")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.bottom], 100)
                .foregroundColor(.white)
            SliderQuestionnaire()
            SliderQuestionnaire()
            SliderQuestionnaire()
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.spaceGrey)
    }
}

struct PreSleepQuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        PreSleepQuestionnaireView()
    }
}
