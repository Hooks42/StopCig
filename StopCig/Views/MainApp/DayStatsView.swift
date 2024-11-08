//
//  DayStatsView.swift
//  StopCig
//
//  Created by Hook on 02/10/2024.
//

import SwiftUI
import Charts

struct DayStatsView: View {
    
    @Binding var smokerModel: SmokerModel?
    @Binding var weekStats : Bool
    
    @State private var indexTabView = 0
    @State private var viewTitle = "Jours"
    @State private var selectedOption = "Argent économisé"
    let options = ["Argent économisé", "Argent perdu", "Cigarettes sauvées", "Cigarettes fumées"]
    
    @State private var graphDataDay : [String : [(String, Int)]] = [:]
    @State private var pickedValue = ""
    @State private var noData = false
    
    
    var body: some View {
        GeometryReader { geo in
            TabView (selection: $indexTabView) {
                ZStack {
                    Color(.nightBlue)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        let data = prepareData(isDay: true)
                        if !data.isEmpty {
                            Chart {
                                ForEach(data, id: \.index) { item in
                                    BarMark (
                                        x: .value("Jour", item.index),
                                        y: .value("Valeur", item.value)
                                    )
                                    .foregroundStyle(.myYellow)
                                }
                            }
                            .onAppear() {
                                self.noData = false
                            }
                            .frame(width: geo.size.width * 0.965, height: geo.size.height * 0.30)
                            .chartXAxis {
                                AxisMarks(values: .automatic) { _ in
                                    AxisTick()
                                    
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading, values: .automatic) { _ in
                                    AxisTick()
                                    AxisValueLabel()
                                }
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geoChart in
                                    Rectangle().fill(.clear).contentShape(Rectangle())
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { value in
                                                    guard let plotFrameValue = proxy.plotFrame else { return }
                                                    let frame = geoChart[plotFrameValue]
                                                    let origin = frame.origin
                                                    let location = CGPoint(
                                                        x: value.location.x - origin.x,
                                                        y: value.location.y - origin.y
                                                    )
                                                    if let (index, _) = proxy.value(at: location, as: (String, Int).self) {
                                                        let newValue = getInfosByIndexInGraphData(model: smokerModel, index: index, selectedOption: self.selectedOption, isDay: true)
                                                        if (newValue != self.pickedValue) {
                                                            self.pickedValue = newValue
                                                        }
                                                    }
                                                }
                                        )
                                }
                            }
                        } else {
                            Text("")
                                .onAppear() {
                                    self.noData = true
                                }
                        }
                    }
                    .padding(.bottom, geo.size.height * 0.01)
                }
                .tag(0)
                
                TabWeekStatsView(selectedOption: $selectedOption, smokerModel: $smokerModel, pickedValue: $pickedValue, noData: $noData, prepareData: prepareData)
                    .tag(1)
            }
            .edgesIgnoringSafeArea(.all)
            .onChange(of: indexTabView) {
                if self.indexTabView == 0 {
                    self.viewTitle = "Jours"
                    self.weekStats = false
                } else if self.indexTabView == 1 {
                    self.viewTitle = "Semaines"
                    self.weekStats = true
                }
            }
            
            ZStack {
                VStack {
                    VStack {
                        Text(self.viewTitle)
                            .font(.custom("Quicksand-SemiBold", size: 30))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, geo.size.height * 0.02)
                    .padding(.leading, geo.size.width * 0.1)
                    VStack (spacing: 35){
                        Menu {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        selectedOption = option
                                    }
                                }) {
                                    Text(option)
                                }
                            }
                        } label: {
                            Text(self.selectedOption)
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .padding(20)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(.myYellow), lineWidth: 2)
                                        .fill(Color(.clear))
                                )
                            
                        }
                        Text(self.pickedValue)
                            .font(.custom("Quicksand-SemiBold", size: 18))
                            .onChange(of: self.pickedValue) {
                                if !self.pickedValue.isEmpty {
                                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                                    haptic.impactOccurred()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            self.pickedValue = ""
                                        }
                                    }
                                }
                            }
                        if self.noData {
                            Text("Aucune donnée disponible !")
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .foregroundColor(.white)
                                .padding(.top, geo.size.height * 0.13)
                        }
                    }
                    .padding(.top, geo.size.height * 0.05)
                }
            }
        }
    }
    
    func prepareData(isDay: Bool) ->  [graphDataStruct] {
        
        let data : [graphDataStruct]?
        if isDay {
            data = (smokerModel?.graphDataDay[selectedOption])
        } else {
            data = (smokerModel?.graphDataWeek[selectedOption])
        }
        if data == nil { return [] }
        
        var newData = Array(data!.dropFirst())
        
        while (newData.count < 7) {
            newData.append(graphDataStruct(index: String(newData.count + 1), value: 0.0))
        }
        return newData
    }
}



struct TabWeekStatsView : View {
    @Binding var selectedOption : String
    @Binding var smokerModel : SmokerModel?
    @Binding var pickedValue : String
    @Binding var noData : Bool
    
    var prepareData : (Bool) -> [graphDataStruct]
    
    var body: some View {
        WeekStatsView(selectedOption: $selectedOption, smokerModel: $smokerModel, pickedValue: $pickedValue, noData: $noData, prepareDataFunction: prepareData)
    }
}

#Preview {
    DayStatsView(smokerModel: .constant(nil), weekStats: .constant(false))
}
