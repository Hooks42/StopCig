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
    @Binding var cigaretSmokedThisDay: Int
    @State private var nextStepAnimation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.gray), lineWidth: 3)
                .frame(width: 380, height: 380)
            
            Circle()
                .trim(from: 0.0, to: nextStep)
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .foregroundColor(Color(.myYellow))
                .frame(width: 380, height: 380) // Taille intermédiaire entre les deux cercles
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 2), value: nextStep)
            VStack {
                Text("Objectif \(cigaretSmokedThisDay) / \(totalCigForThisDay)")
                    .font(.custom("Quicksand-Light", size:30))
                    .foregroundColor(Color(.myYellow))
            }
        }
    }
}

#Preview {
    CircleView(nextStep: .constant(0.5), totalCigForThisDay: .constant(0), cigaretSmokedThisDay: .constant(0))
}
