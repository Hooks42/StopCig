//
//  MainBoardView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct MainBoardView: View {
    
    @Binding var smokerModel: SmokerModel?
    @State var nextStep: CGFloat = 0
    @State var gain :Double = 0
    
    init(smokerModel: Binding<SmokerModel?>) {
        self._smokerModel = smokerModel
        self._gain = State(initialValue: smokerModel.wrappedValue?.gain ?? 0)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    CircleView(nextStep: $nextStep)
                }
                .padding(.bottom, 50)
                    
                VStack {
                    GainAndLossView(gain: $gain)
                }
                .padding(.bottom, 600)
                    
                VStack {
                    Spacer()
                    Button(action: {
                        self.nextStep = 0.9999999
                    }) {
                        Text("Next Step")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(Color(.nightBlue))
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
        cigaretSmoked: CigaretDayCount(thisDay: 0, thisWeek: 0, thisMonth: 0),
        gain: 0.0,
        needToReset: false
    ))
    )
}
