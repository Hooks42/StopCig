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
    //@Binding var circleAnimation: Bool
    @Binding var circleScale: CGFloat
    @Binding var resistance: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(Color(.gray), lineWidth: 3)
                    .frame(width: geo.size.width * 0.90 * circleScale, height: geo.size.height * 0.90 * circleScale)
                
                Circle()
                    .trim(from: 0.0, to: nextStep)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .foregroundColor(Color(.myYellow))
                    .frame(width: geo.size.width * 0.90 * circleScale, height: geo.size.height * 0.90 * circleScale) // Taille intermédiaire entre les deux cercles
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: nextStep)
                VStack {
                    Text("Objectif \(cigaretSmokedThisDay) / \(totalCigForThisDay)")
                        .font(.custom("Quicksand-Light", size:30))
                        .foregroundColor(Color(.myYellow))
                }
            }
            .padding(.leading, geo.size.width * 0.05)
        }
    }
}

//#Preview {
//    CircleView(nextStep: .constant(1), totalCigForThisDay: .constant(0), cigaretSmokedThisDay: .constant(0), circleScale: .constant(1), resistance: .constant(1))
//}
