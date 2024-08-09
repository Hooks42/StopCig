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
                VStack {
                    Spacer()
                    Button(action: {
                        self.nextStep = 0.9999999
                    }) {
                        Text("Next Step")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(.nightBlue))
                            .padding()
                            .background(Color(.myRed))
                            .cornerRadius(10)
                    }
                    Button(action: {
                        self.nextStep = 0.2
                    }) {
                        Text("Next Step")
                    }
                    Image("Xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 210)
                }
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
