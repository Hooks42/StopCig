//
//  TextView.swift
//  StopCig
//
//  Created by Hook on 15/11/2024.
//

import SwiftUI


struct TextView: View {
    var text: String
    
    @Binding var optionFrame: CGRect
    
    @Binding var optionPoliceLength: CGFloat
    var body: some View {
        Text(text)
            .font(.custom("Quicksand-SemiBold", size: optionPoliceLength))
            .foregroundColor(.white)
            .padding()
            .background(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.clear)
                        .onAppear {
                            self.optionFrame = geometry.frame(in: .global)
                        }
                        .onChange(of: geometry.frame(in: .global)) {
                            self.optionFrame = geometry.frame(in: .global)
                        }
                }
            )
    }
}
