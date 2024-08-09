//
//  MainBoardView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct MainBoardView: View {
    
    @State var nextStep: CGFloat = 0.0
    
    @Binding var smokerModel: SmokerModel?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                CircleView(nextStep: $nextStep)
                    .padding(.bottom, 240)
                VStack {
                    Text("267 ")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green) +
                    Text("EUR")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                }
                .position(x: geo.size.width * 0.2, y: geo.size.height * 0.080)
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
