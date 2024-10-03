//
//  WeekStatsView.swift
//  StopCig
//
//  Created by Hook on 03/10/2024.
//

import SwiftUI

struct WeekStatsView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                Text("Ici seront les stats à la semaine")
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    WeekStatsView()
}
