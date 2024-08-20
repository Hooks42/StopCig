//
//  CircleView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    @Binding var nextStep: CGFloat
    @Binding var totalCigForThisDay: Int
    @State private var nextStepAnimation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.white), lineWidth: 3)
                .frame(width: 280, height: 280)
            Circle()
                .stroke(Color(.white), lineWidth: 3)
                .frame(width: 240, height: 240)
            
            Circle()
                .stroke(Color(.myLightBlue), lineWidth: 25) // Cercle jaune très sombre
                .frame(width: 260, height: 260)
            
            Circle()
                .trim(from: 0.014, to: nextStep)
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .foregroundColor(Color(.nightBlue))
                .frame(width: 260, height: 260) // Taille intermédiaire entre les deux cercles
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 2), value: nextStep)
            
            Text("\(totalCigForThisDay)")
                .font(.custom("Quicksand-Light", size:60))
                .bold()
                .foregroundColor(Color(.myGreen))
        }
    }
}

#Preview {
    CircleView(nextStep: .constant(0.3), totalCigForThisDay: .constant(0))
}
