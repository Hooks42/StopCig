//
//  CircleView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    @Binding var nextStep: CGFloat
    @State private var nextStepAnimation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.nightBlue), lineWidth: 3)
                .frame(width: 280, height: 280)
            Circle()
                .stroke(Color(.nightBlue), lineWidth: 3)
                .frame(width: 240, height: 240)
            if nextStep >= 1.0 {
                Circle()
                    .trim(from: 0, to: nextStep)
                    .stroke(style: StrokeStyle(lineWidth: 17, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(.myRed)).frame(width: 260, height: 260)// Taille intermédiaire entre les deux cercles
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 2), value: nextStep)
            } else {
                Circle()
                    .trim(from: 0.014, to: nextStep)
                    .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color(.myGreen), Color(.myYellow), Color(.myRed)]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 25, lineCap: .round)
                )
                    .foregroundColor(Color(.myRed)).frame(width: 260, height: 260)// Taille intermédiaire entre les deux cercles
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 2), value: nextStep)
            }
            Text("10")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(Color(.myGreen))
        }
//        .onAppear {
//            withAnimation(.linear(duration: 2)) {
//                nextStepAnimation = nextStep
//            }
//        }
    }
}

#Preview {
    CircleView(nextStep: .constant(0.3))
}
