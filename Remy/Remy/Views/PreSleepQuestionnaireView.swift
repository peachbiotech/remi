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
            HStack {
                NavigationLink(destination: LiveSessionView().onAppear(perform: {
                    print("questionnaire skip")
                    })
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.gray)
                        .frame(width: 150, height: 50)
                        Text("skip").foregroundColor(.white)
                    }
                }
                NavigationLink(destination: LiveSessionView().onAppear(perform: {
                    print("questionnaire filled")
                    })
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.blue)
                        .frame(width: 150, height: 50)
                        Text("continue").foregroundColor(.white)
                    }
                }
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.midNightBlue)
    }
}

struct PreSleepQuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        PreSleepQuestionnaireView()
    }
}
