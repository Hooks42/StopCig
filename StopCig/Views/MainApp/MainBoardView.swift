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
    @Binding var addDay: Bool
    @Binding var startTest: Bool
    
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
    
    init(smokerModel: Binding<SmokerModel?>, needToReset: Binding<Bool>, addDay: Binding<Bool>, startTest: Binding<Bool>) {
        self._smokerModel = smokerModel
        self._needToReset = needToReset
        self._addDay = addDay
        self._startTest = startTest
        
        self._totalCigForThisDay = State(initialValue: smokerModel.wrappedValue?.numberOfCigaretProgrammedThisDay ?? 0)
        self._cigaretSmokedThisDay = State(initialValue: smokerModel.wrappedValue?.cigaretCountThisDayMap[getOnlyDate(from: smokerModel.wrappedValue?.lastOpening ?? Date())]?.cigaretSmoked ?? 0)
        
        let cigPackPrice = smokerModel.wrappedValue?.cigaretInfo.priceOfCigaret ?? 0
        self.cigPrice = Double(cigPackPrice) / 20
        
        //self._nextStep = State(initialValue: 1 / CGFloat(totalCigForThisDay) * CGFloat(cigaretSmokedThisDay))
        
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
                    Text("Objectif \(cigaretSmokedThisDay) / \(totalCigForThisDay)")
                        .font(.custom("Quicksand-Light", size:30))
                        .foregroundColor(Color(.myYellow))
                        .animation(nil, value: cigaretSmokedThisDay)
                }
                .padding(.top, geo.size.height * 0.04)
                VStack {
                    CircleView(nextStep: $nextStep, circleScale: $circleScale, resistance: $resistance)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.5)
                }
                .padding(.top, geo.size.height * 0.08)
                Circle()
                    .fill(Color.white.opacity(0))
                    .contentShape(Circle())
                    .onLongPressGesture(minimumDuration: 0.4) {
                        if self.cigaretSmokedThisDay > 0 {
                            let haptic = UIImpactFeedbackGenerator(style: .heavy)
                            haptic.impactOccurred()
                            self.nextStep -= 1 / CGFloat(totalCigForThisDay)
                            self.cigaretSmokedThisDay -= 1
                            withAnimation(.spring()) {
                                self.gain += cigPrice
                            }
                            if smokerModel != nil {
                                smokerModel!.cigaretTotalCount.gain = self.gain
                                let date = getOnlyDate(from: smokerModel!.lastOpening)
                                smokerModel!.cigaretCountThisDayMap[date]?.cigaretSmoked -= 1
                                smokerModel!.cigaretCountThisDayMap[date]?.gain += self.cigPrice
                                if let stats = smokerModel!.cigaretCountThisDayMap[date] {
                                    if stats.lost - self.cigPrice > 0 {
                                        smokerModel!.cigaretCountThisDayMap[date]?.gain -= self.cigPrice
                                    } else {
                                        smokerModel!.cigaretCountThisDayMap[date]?.gain = 0
                                    }
                                }
                                
                                saveInSmokerDb(modelContext)
                                let cigSave = self.totalCigForThisDay - smokerModel!.cigaretCountThisDayMap[date]!.cigaretSmoked
                                if cigSave > 0 {
                                    smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved = cigSave
                                    smokerModel!.cigaretCountThisDayMap[date]?.gain = self.cigPrice * Double(cigSave)
                                } else {
                                    smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved = 0
                                    smokerModel!.cigaretCountThisDayMap[date]?.gain = 0
                                }
                                
                                let cigSmoked = smokerModel!.cigaretCountThisDayMap[date]!.cigaretSmoked
                                if cigSmoked > 0 {
                                    smokerModel!.cigaretCountThisDayMap[date]?.lost = self.cigPrice * Double(cigSmoked)
                                } else {
                                    smokerModel!.cigaretCountThisDayMap[date]?.lost = 0
                                }
                                saveInSmokerDb(modelContext)
                                
                            }
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.circleScale = max(0.7, self.circleScale - 0.1)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                let haptic = UIImpactFeedbackGenerator(style: .light)
                                haptic.impactOccurred()
                                withAnimation(.interpolatingSpring(stiffness: 50, damping: 5, initialVelocity: 10)) {
                                    self.circleScale = 1.0
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        let haptic = UIImpactFeedbackGenerator(style: .light)
                        haptic.impactOccurred()
                        self.nextStep += 1 / CGFloat(totalCigForThisDay)
                        self.cigaretSmokedThisDay += 1
                        withAnimation(.easeInOut(duration: 1)) {
                            self.gain -= cigPrice
                        }
                        if smokerModel != nil {
                            smokerModel!.cigaretTotalCount.gain = gain
                            let date = getOnlyDate(from: smokerModel!.lastOpening)
                            
                            smokerModel!.cigaretCountThisDayMap[date]?.cigaretSmoked += 1
                            if let stats = smokerModel!.cigaretCountThisDayMap[date] {
                                if stats.gain - self.cigPrice > 0 {
                                    smokerModel!.cigaretCountThisDayMap[date]?.gain -= self.cigPrice
                                } else {
                                    smokerModel!.cigaretCountThisDayMap[date]?.gain = 0
                                }
                            }
                            saveInSmokerDb(modelContext)
                            
                            let cigSave = self.totalCigForThisDay - smokerModel!.cigaretCountThisDayMap[date]!.cigaretSmoked
                            if cigSave > 0 {
                                smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved = cigSave
                                smokerModel!.cigaretCountThisDayMap[date]?.gain = self.cigPrice * Double(cigSave)
                            } else {
                                smokerModel!.cigaretCountThisDayMap[date]?.cigaretSaved = 0
                                smokerModel!.cigaretCountThisDayMap[date]?.gain = 0
                            }
                            
                            let cigSmoked = smokerModel!.cigaretCountThisDayMap[date]!.cigaretSmoked
                            if cigSmoked > 0 {
                                smokerModel!.cigaretCountThisDayMap[date]?.lost = self.cigPrice * Double(cigSmoked)
                            } else {
                                smokerModel!.cigaretCountThisDayMap[date]?.lost = 0
                            }
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
                if self.startTest {
                    Button(action: {
                        self.addDay = true
                    }) {
                        Text("+1 Day")
                            .font(.custom("Quicksand-SemiBold", size: 20))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.myYellow))
                            .cornerRadius(15)
                    }
                    .padding(.top, geo.size.height * 0.6)
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
        MainBoardView(smokerModel: .constant(nil), needToReset: .constant(false), addDay: .constant(false), startTest: .constant(true))
    }
