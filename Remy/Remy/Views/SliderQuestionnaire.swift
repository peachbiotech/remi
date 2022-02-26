//
//  SliderQuestionnaire.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/15/22.
//

import SwiftUI

struct SliderQuestionnaire: View {
    @State private var sliderVal = 0.0
    @State private var isEditing = false
    var sliderMin: Double = 0
    var sliderMax: Double = 10
    var sliderStep: Double = 1
    var questionIcon: Image = Image(systemName: "eyes")
    var question: String = "Trick question"

    var body: some View {
        VStack {
            HStack {
                Text(question).foregroundColor(.white)
                Spacer()
                Text("\(Int(sliderVal))")
                    .foregroundColor(isEditing ? .blue : .white)
                questionIcon.foregroundColor(.white)
            }
            Slider(
                value: $sliderVal,
                in: sliderMin...sliderMax,
                step: sliderStep
            ) {
                Text(question)
            } onEditingChanged: { editing in
                isEditing = editing
            }
        }.padding(20.0)
    }
}

struct SliderQuestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        SliderQuestionnaire(
        )
    }
}
