//
//  GainAndLossView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct GainAndLossView: View {
    
    @Binding var gain: Double
    @Binding var loss: Double
    
    var body: some View {
        HStack {
            VStack {
                Text("267 ")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green) +
                Text("EUR")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.leading, 20)
            .padding(.bottom, 650)
                Spacer()
            VStack {
                Text("18 ")
                    .font(.title)
                    .bold()
                    .foregroundColor(.red) +
                Text("EUR")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 650)
        }

    }
}

#Preview {
    GainAndLossView(gain: .constant(267), loss: .constant(18))
}
