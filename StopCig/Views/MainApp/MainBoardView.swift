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
    @State var totalCigForThisDay = 0
    @State var cigaretSmokedThisDay = 0
    @State var currentPage = 0
    
    init(smokerModel: Binding<SmokerModel?>) {
        self._smokerModel = smokerModel
        
        let initialCigCount = smokerModel.wrappedValue?.cigaretInfo.numberOfCigaretAnnounced ?? 0
        let cigPercentage = Int(floor(Double(initialCigCount) * 0.20))
        self._totalCigForThisDay = State(initialValue: initialCigCount - cigPercentage)
        
        let cigPackPrice = smokerModel.wrappedValue?.cigaretInfo.priceOfCigaret ?? 0
        let cigPrice = Double(cigPackPrice) / 20
        self._gain = State(initialValue: Double(cigPrice) * Double(totalCigForThisDay))
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    RectangleSelecterView(currentPage: $currentPage)
                }
                .padding(.top, 25)
                VStack {
                    CircleView(nextStep: $nextStep, totalCigForThisDay: $totalCigForThisDay, cigaretSmokedThisDay: $cigaretSmokedThisDay)
                }
                .padding(.bottom, 50)
                    
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
    MainBoardView(smokerModel: .constant(nil))
}
