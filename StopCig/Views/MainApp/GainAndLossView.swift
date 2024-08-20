//
//  GainAndLossView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct GainAndLossView: View {
    
    @Binding var gain: Double
    
    var body: some View {
        if gain >= 0 {
            Text("\(gain.formatted()) €")
                .font(.custom("Quicksand-Light", size: 40))
                .foregroundColor(Color(.green))
        } else {
            Text("\(gain.formatted()) €")
                .font(.custom("Quicksand-Light", size: 40))
                .foregroundColor(Color(.myRed))
        }
    }
}

#Preview {
    GainAndLossView(gain: .constant(-267.34))
}
