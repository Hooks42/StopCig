//
//  CircleView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    @Binding var nextStep: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.nightBlue), lineWidth: 3)
                .frame(width: 280, height: 280)
            Circle()
                .stroke(Color(.nightBlue), lineWidth: 3)
                .frame(width: 240, height: 240)
            Circle()
                .trim(from: 0, to: nextStep)
                .stroke(style: StrokeStyle(lineWidth: 17, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(.myPurple)).frame(width: 260, height: 260)// Taille intermédiaire entre les deux cercles
                .rotationEffect(.degrees(-90))
            Text("10")
                .font(.custom("Quicksand-Light", size: 50))
                .foregroundColor(.green)
        }
        .onAppear {
            withAnimation(.linear(duration: 2)) {
                nextStep = 0.9
            }
        }
    }
}

#Preview {
    CircleView(nextStep: .constant(0.3))
}
