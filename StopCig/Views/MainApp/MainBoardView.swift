//
//  MainBoardView.swift
//  StopCig
//
//  Created by Hook on 09/08/2024.
//

import SwiftUI

struct MainBoardView: View {
    
    @Binding var smokerModel: SmokerModel?
    @Binding var needToReset: Bool
    @Environment(\.modelContext) private var modelContext
    
    @State private var timer: Timer?
    
    //@State var circleAnimation = false
    @State var circleScale: CGFloat = 1.0
    @State var resistance: CGFloat = 1.0
    
    
    
    @State var nextStep: CGFloat = 0
    @State var gain : Double = 0
    @State var totalCigForThisDay = 0
    @State var cigaretSmokedThisDay = 0
    @State var showSettings = false
    @State var CigPerDay = 0
    @State var packPrice = 0.0
    private let cigPrice : Double
    
    init(smokerModel: Binding<SmokerModel?>, needToReset: Binding<Bool>) {
        self._smokerModel = smokerModel
        self._needToReset = needToReset
        
        self._totalCigForThisDay = State(initialValue: smokerModel.wrappedValue?.numberOfCigaretProgrammedThisDay ?? 0)
        self._cigaretSmokedThisDay = State(initialValue: smokerModel.wrappedValue?.cigaretCountThisDayMap[getOnlyDate(from: smokerModel.wrappedValue?.lastOpening ?? Date())]?.cigaretSmoked ?? 0)
        
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
                HStack {
                    Image("money")
                        .resizable()
                        .frame(width: geo.size.width * 0.09, height: geo.size.width * 0.09)
                        .padding(.leading, geo.size.height * 0.04)
                    Text(String(format: "%.2f", gain))
                        .font(.custom("Quicksand-SemiBold", size: 28))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(width:geo.size.width * 0.15, alignment: .leading)
                    Text("€")
                        .font(.custom("Quicksand-SemiBold", size: 28))
                        .foregroundColor(.white)
                    Spacer().frame(width: geo.size.width * 0.4)
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
                .padding(.trailing, geo.size.width * 0.1)
                VStack {
                    CircleView(nextStep: $nextStep, totalCigForThisDay: $totalCigForThisDay, cigaretSmokedThisDay: $cigaretSmokedThisDay, circleScale: $circleScale, resistance: $resistance)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.5)
                }
                .padding(.top, geo.size.height * 0.08)
                Circle()
                    .fill(Color.white.opacity(0))
                    .contentShape(Circle())
                    .onLongPressGesture(minimumDuration: 0.4) {
                        if self.cigaretSmokedThisDay > 0 {
                            self.nextStep -= 1 / CGFloat(totalCigForThisDay)
                            self.cigaretSmokedThisDay -= 1
                            withAnimation(.spring()) {
                                self.gain += cigPrice
                            }
                            if smokerModel != nil {
                                smokerModel!.cigaretTotalCount.gain = self.gain
                                let date = getOnlyDate(from: smokerModel!.lastOpening)
                                
                                smokerModel!.cigaretCountThisDayMap[date]?.cigaretSmoked -= 1
                                smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved += 1
                                smokerModel!.cigaretCountThisDayMap[date]?.gain += self.cigPrice
                                smokerModel!.cigaretCountThisDayMap[date]?.lost -= self.cigPrice
                                saveInSmokerDb(modelContext)
                            }
                            withAnimation(.easeInOut(duration: 0.7)) {
                                self.circleScale = max(0.7, self.circleScale - 0.05)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation(.interpolatingSpring(stiffness: 50, damping: 5, initialVelocity: 10)) {
                                    self.circleScale = 1.0
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        self.nextStep += 1 / CGFloat(totalCigForThisDay)
                        self.cigaretSmokedThisDay += 1
                        withAnimation(.easeInOut(duration: 1)) {
                            self.gain -= cigPrice
                        }
                        if smokerModel != nil {
                            smokerModel!.cigaretTotalCount.gain = gain
                            let date = getOnlyDate(from: smokerModel!.lastOpening)
                            
                            smokerModel!.cigaretCountThisDayMap[date]?.cigaretSmoked += 1
                            smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved -= 1
                            smokerModel!.cigaretCountThisDayMap[date]?.gain -= self.cigPrice
                            smokerModel!.cigaretCountThisDayMap[date]?.lost += self.cigPrice
                            saveInSmokerDb(modelContext)
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.circleScale = max(0.7, self.circleScale - 0.05)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.interpolatingSpring(stiffness: 50, damping: 5, initialVelocity: 10)) {
                                self.circleScale = 1.0
                            }
                        }
                    }
            }
            .onAppear() {
                if smokerModel?.firstOpeningDate != nil {
                    print("✅ La date d'aujourd'hui est : \(String(describing: smokerModel?.firstOpeningDate!))")
                }
                let i = self.nextStep
                if nextStep != 0 {
                    withAnimation {
                        nextStep = 0
                        nextStep = i
                    }
                }
            }
            .onChange(of: needToReset) {
                if needToReset == true {
                    self.nextStep = 0
                    self.cigaretSmokedThisDay = 0
                    self.gain += self.cigPrice * Double(self.totalCigForThisDay)
                    needToReset = false
                    
                }
            }
        }
    }
}
    
    #Preview {
        MainBoardView(smokerModel: .constant(nil), needToReset: .constant(false))
    }
