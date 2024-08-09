//
//  CircleView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    @State private var nextStep: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color(.nightBlue)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .stroke(Color(.myPurple), lineWidth: 3)
                .frame(width: 200, height: 200)
            Circle()
                .stroke(Color(.myPurple), lineWidth: 3)
                .frame(width: 150, height: 150)
            Circle()
                .trim(from: 0, to: nextStep)
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .foregroundColor(Color(.yellow)).frame(width: 175, height: 175) // Taille intermédiaire entre les deux cercles
                .rotationEffect(.degrees(-90))
            Text("10")
                .font(.custom("Quicksand-Light", size: 50))
                .foregroundColor(.green)
        }
        .onAppear {
            withAnimation(.linear(duration: 2)) {
                nextStep = 0.3
            }
        }
    }
}

#Preview {
    CircleView()
}
