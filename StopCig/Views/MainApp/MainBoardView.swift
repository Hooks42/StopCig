//
//  MainBoardView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct MainBoardView: View {
    
    @State var nextStep: CGFloat = 0.0
    @State var gain :Double = 0
    @State var loss :Double = 0
    
    @Binding var smokerModel: SmokerModel?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                CircleView(nextStep: $nextStep)
                GainAndLossView(gain: $gain, loss: $loss)
            }
        }
    }
}

#Preview {
    MainBoardView(smokerModel: .constant(SmokerModel(
        firstOpening: false,
        cigaretInfo: CigaretInfos(kindOfCigaret: "", priceOfCigaret: 0.0, numberOfCigaretAnnounced: 0),
        numberOfCigaretProgrammedThisDay: 0,
        cigaretSmoked: CigaretCount(thisDay: 0, thisWeek: 0, thisMonth: 0),
        cigaretSaved: CigaretCount(thisDay: 0, thisWeek: 0, thisMonth: 0)
    ))
    )
}
