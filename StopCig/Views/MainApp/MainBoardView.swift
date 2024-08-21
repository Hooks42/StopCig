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
        //self._gain = State(initialValue: Double(cigPrice) * Double(totalCigForThisDay))
        self._gain = State(initialValue: 273.27)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Wallet: \(gain.formatted()) €")
                        .font(.custom("Quicksand-SemiBold", size: 28))
//                    RectangleSelecterView(currentPage: $currentPage)
                }
                .padding(.bottom, 750)
                .padding(.trailing, 280)
                VStack {
                    CircleView(nextStep: $nextStep, totalCigForThisDay: $totalCigForThisDay, cigaretSmokedThisDay: $cigaretSmokedThisDay)
                }
                .padding(.bottom, 50)
                    
                HStack (spacing: 20) {
                    Button(action: {
                        if self.nextStep > 0 {
                            self.nextStep -= 0.2
                        }
                    }) {
                        Image("xmark")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    Button(action: {
                        if self.nextStep < 1 {
                            self.nextStep += 0.2
                        }
                    }) {
                        Image("checkmark")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.top, 480)
                
            }
        }
    }
}

#Preview {
    MainBoardView(smokerModel: .constant(nil))
}
