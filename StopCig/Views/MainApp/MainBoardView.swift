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
    @State var showSettings = true
    @State var CigPerDay = 0
    @State var packPrice = 0.0
    
    init(smokerModel: Binding<SmokerModel?>) {
        self._smokerModel = smokerModel
        
        let initialCigCount = smokerModel.wrappedValue?.cigaretInfo.numberOfCigaretAnnounced ?? 0
        let cigPercentage = Int(floor(Double(initialCigCount) * 0.20))
        self._totalCigForThisDay = State(initialValue: initialCigCount - cigPercentage)
        
        let cigPackPrice = smokerModel.wrappedValue?.cigaretInfo.priceOfCigaret ?? 0
        let cigPrice = Double(cigPackPrice) / 20
        self._gain = State(initialValue: Double(cigPrice) * Double(totalCigForThisDay))
        self._gain = State(initialValue: 273.27)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Wallet: ")
                            .font(.custom("Quicksand-SemiBold", size: 28))
                        //                    RectangleSelecterView(currentPage: $currentPage)
                        Text("\(gain.formatted()) €")
                            .font(.custom("Quicksand-SemiBold", size: 28))
                            .padding(.leading, geo.size.width * 0.025)
                    }
                    .padding(.bottom, geo.size.height * 0.85)
                    .padding(.trailing, geo.size.width * 0.60)
                    VStack {
                        Button(action: {
                            showSettings.toggle()
                        }) {
                            Image("settingsIcon")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .sheet(isPresented: $showSettings) {
                                    ZStack {
                                        Color(.nightBlue)
                                        SettingsView(smokerModel: $smokerModel)
                                    }
                                    .presentationDetents([.fraction(geo.size.height * 0.0005)])
                                    .edgesIgnoringSafeArea(.all)
                                }
                        }
                    }
                    .padding(.bottom, geo.size.height * 0.85)
                    .padding(.leading, geo.size.width * 0.65)
                    VStack {
                        CircleView(nextStep: $nextStep, totalCigForThisDay: $totalCigForThisDay, cigaretSmokedThisDay: $cigaretSmokedThisDay)
                    }
                    .padding(.bottom, geo.size.height * 0.05)
                    
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
                    .padding(.top, geo.size.height * 0.5)
            }
        }
    }
}
    
    #Preview {
        MainBoardView(smokerModel: .constant(nil))
    }
