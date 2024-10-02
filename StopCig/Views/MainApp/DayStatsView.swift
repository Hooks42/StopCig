//
//  DayStatsView.swift
//  StopCig
//
//  Created by Hook on 02/10/2024.
//

import SwiftUI

struct DayStatsView: View {
    
    @Binding var indexTabView: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                Text("ICI CA FAIT DES STATS OU QUOI ??")
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    DayStatsView(indexTabView: .constant(0))
}
