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
    
    let moneyEarned = [
        ("1", 10),
        ("2", 13),
        ("3", 09),
        ("4", 11),
        ("5", 13),
        ("6", 9),
        ("7", 8),
        ("8", 11),
        ("9", 12),
        ("10", 12),
        ("11", 09),
        ("12", 12),
        ("13", 14),
        ("14", 16),
        ("15", 12),
        ("16", 13),
        ("17", 6),
        ("18", 7),
        ("19", 9),
        ("20", 11),
    ]
    let moneyLost = [
        ("1", 2),
        ("2", 3),
        ("3", 1),
        ("4", 2),
        ("5", 3),
        ("6", 2),
        ("7", 2),
        ("8", 3),
        ("9", 3),
        ("10", 3),
        ("11", 1),
        ("12", 3),
        ("13", 4),
        ("14", 5),
        ("15", 3),
        ("16", 3),
        ("17", 1),
        ("18", 1),
        ("19", 2),
        ("20", 2),
    ]
    let cigaretSaved = [
        ("1", 1),
        ("2", 2),
        ("3", 1),
        ("4", 2),
        ("5", 2),
        ("6", 1),
        ("7", 1),
        ("8", 2),
        ("9", 2),
        ("10", 2),
        ("11", 1),
        ("12", 2),
        ("13", 3),
        ("14", 3),
        ("15", 2),
        ("16", 2),
        ("17", 1),
        ("18", 1),
        ("19", 1),
        ("20", 2),
    ]
    let cigaretSmoked = [
        ("1", 11),
        ("2", 12),
        ("3", 10),
        ("4", 11),
        ("5", 12),
        ("6", 10),
        ("7", 10),
        ("8", 12),
        ("9", 12),
        ("10", 12),
        ("11", 10),
        ("12", 12),
        ("13", 13),
        ("14", 14),
        ("15", 12),
        ("16", 12),
        ("17", 9),
        ("18", 10),
        ("19", 10),
        ("20", 11),
    ]
    
    let WmoneyEarned = [
        ("1", 18),
        ("2", 23),
        ("3", 15),
        ("4", 22),
        ("5", 23),
    ]
    let WmoneyLost = [
        ("1", 7),
        ("2", 10),
        ("3", 4),
        ("4", 7),
        ("5", 10),
        
    ]
    let WcigaretSaved = [
        ("1", 7),
        ("2", 6),
        ("3", 5),
        ("4", 6),
        ("5", 7),
    ]
    let WcigaretSmoked = [
        ("1", 25),
        ("2", 30),
        ("3", 20),
        ("4", 25),
        ("5", 30),
    ]
    
    @State private var graphData : [String : [(String, Int)]] = [:]
    @State private var pickedValue = ""
    
    
    var body: some View {
        GeometryReader { geo in
            TabView (selection: $indexTabView) {
                ZStack {
                    Color(.nightBlue)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Chart {
                            if let data = smokerModel?.graphData[selectedOption] {
                                let newdata = data.dropFirst()
                                ForEach(newdata, id: \.index) { item in
                                    BarMark (
                                        x: .value("Jour", item.index),
                                        y: .value("Valeur", item.value)
                                    )
                                    .foregroundStyle(.myYellow)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.965, height: geo.size.height * 0.30)
                        .chartYAxis {
                            AxisMarks(position: .leading)
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
                                            self.pickedValue = getInfosByIndexInGraphData(model: smokerModel, index: index, selectedOption: self.selectedOption)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.bottom, geo.size.height * 0.01)
                }
                .tag(0)
                
                TabWeekStatsView(selectedOption: $selectedOption, graphData: $graphData)
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
            .onAppear {
                self.graphData = [
                    "Argent économisé" : moneyEarned,
                    "Argent perdu" : moneyLost,
                    "Cigarettes sauvées" : cigaretSaved,
                    "Cigarettes fumées" : cigaretSmoked,
                    "WArgent économisé" : WmoneyEarned,
                    "WArgent perdu" : WmoneyLost,
                    "WCigarettes sauvées" : WcigaretSaved,
                    "WCigarettes fumées" : WcigaretSmoked
                    ]
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
                            .animation(.easeInOut(duration: 0.5), value: self.pickedValue)
                            .onChange(of: self.pickedValue) {
                                if !self.pickedValue.isEmpty {
                                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                                    haptic.impactOccurred()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            self.pickedValue = ""
                                        }
                                    }
                                }
                            }
                    }
                    .padding(.top, geo.size.height * 0.05)
                }
            }
        }
    }
}

struct TabWeekStatsView : View {
    @Binding var selectedOption : String
    @Binding var graphData : [String : [(String, Int)]]
    
    var body: some View {
        WeekStatsView(selectedOption: $selectedOption, graphData: $graphData)
    }
}

#Preview {
    DayStatsView(smokerModel: .constant(nil), weekStats: .constant(false))
}
