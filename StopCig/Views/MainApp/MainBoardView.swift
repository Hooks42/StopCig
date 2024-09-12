//
//  MainBoardView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct MainBoardView: View {
    
    @Binding var smokerModel: SmokerModel?
    @Environment(\.modelContext) private var modelContext
    
    @State private var timer: Timer?
    
    

    @State var nextStep: CGFloat = 0
    @State var gain : Double = 0
    @State var totalCigForThisDay = 0
    @State var cigaretSmokedThisDay = 0
    @State var currentPage = 0
    @State var showSettings = false
    @State var CigPerDay = 0
    @State var packPrice = 0.0
    private let cigPrice : Double
    
    init(smokerModel: Binding<SmokerModel?>) {
        self._smokerModel = smokerModel
        
        self._totalCigForThisDay = State(initialValue: smokerModel.wrappedValue?.numberOfCigaretProgrammedThisDay ?? 0)
        self._cigaretSmokedThisDay = State(initialValue: smokerModel.wrappedValue?.cigaretCountThisDayMap[Date()]?.cigaretSmoked ?? 0)
        
        let cigPackPrice = smokerModel.wrappedValue?.cigaretInfo.priceOfCigaret ?? 0
        self.cigPrice = Double(cigPackPrice) / 20
        
        self._nextStep = State(initialValue: 1 / CGFloat(totalCigForThisDay) * CGFloat(cigaretSmokedThisDay))
        
        self._gain = State(initialValue: smokerModel.wrappedValue?.cigaretTotalCount.gain ?? 0)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Wallet: ")
                            .font(.custom("Quicksand-SemiBold", size: 28))
                            .foregroundColor(.white)
                        //                    RectangleSelecterView(currentPage: $currentPage)
                        Text(String(format: "%.2f", gain) + " €")
                            .font(.custom("Quicksand-SemiBold", size: 28))
                            .padding(.leading, geo.size.width * 0.025)
                            .foregroundColor(.white)
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
                            print("xmark nextstep : \(nextStep)")
                            if self.cigaretSmokedThisDay > 0 {
                                print("CigaretSmokedThisDay --> \(cigaretSmokedThisDay)")
                                self.nextStep -= 1 / CGFloat(totalCigForThisDay)
                                self.cigaretSmokedThisDay -= 1
                                withAnimation(.spring()) {
                                    self.gain += cigPrice
                                }
                                if smokerModel != nil {
                                    smokerModel!.cigaretTotalCount.gain = gain
                                    smokerModel!.cigaretCountThisDayMap[Date()]?.cigaretSmoked = cigaretSmokedThisDay
                                    saveInSmokerDb(modelContext)
                                }
                            }
                        })
                        {
                            Image("xmark")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                        Button(action: {
                            if self.cigaretSmokedThisDay < totalCigForThisDay {
                                self.nextStep += 1 / CGFloat(totalCigForThisDay)
                                self.cigaretSmokedThisDay += 1
                                withAnimation(.easeInOut(duration: 1)) {
                                    self.gain -= cigPrice
                                }
                                if smokerModel != nil {
                                    smokerModel!.cigaretTotalCount.gain = gain
                                    smokerModel!.cigaretCountThisDayMap[Date()]?.cigaretSmoked = cigaretSmokedThisDay
                                    saveInSmokerDb(modelContext)
                                }
                            }
                        }) {
                            Image("checkmark")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.top, geo.size.height * 0.5)
            }
            .onAppear() {
                let i = self.nextStep
                if nextStep != 0 {
                    withAnimation {
                        nextStep = 0
                        nextStep = i
                    }
                }
            }
        }
    }
}
    
    #Preview {
        MainBoardView(smokerModel: .constant(nil))
    }
