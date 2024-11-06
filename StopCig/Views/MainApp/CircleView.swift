//
//  CircleView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    @Binding var nextStep: CGFloat
    //@Binding var circleAnimation: Bool
    @Binding var circleScale: CGFloat
    @Binding var resistance: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(Color(.gray), lineWidth: 3)
                    .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.90)
                    .scaleEffect(circleScale)
                
                Circle()
                    .trim(from: 0.0, to: nextStep)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .foregroundColor(Color(.myYellow))
                    .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.90) // Taille intermédiaire entre les deux cercles
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(circleScale)
            }
            .padding(.leading, geo.size.width * 0.05)
        }
    }
}

#Preview {
    CircleView(nextStep: .constant(1), circleScale: .constant(1), resistance: .constant(1))
}
