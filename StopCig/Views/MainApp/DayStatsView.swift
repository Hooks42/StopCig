//
//  DayStatsView.swift
//  StopCig
//
//  Created by Hook on 02/10/2024.
//

import SwiftUI
import Charts

struct DayStatsView: View {
    
    @Binding var weekStats : Bool
    @State var indexTabView = 0
    @State private var viewTitle = "Jours"
    @State private var selectedOption = "Argent économisé"
    let options = ["Argent économisé", "Argent perdu", "Cigarettes sauvées", "Cigarettes fumées"]
    
    let data = [
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
    
    var body: some View {
        GeometryReader { geo in
            TabView (selection: $indexTabView) {
                ZStack {
                    Color(.nightBlue)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Chart {
                            ForEach(data, id: \.0) { item in
                                BarMark (
                                    x: .value("Jour", item.0),
                                    y: .value("Valeur", item.1)
                                )
                                .foregroundStyle(.myYellow)
                                
                            }
                        }
                        .frame(width: geo.size.width * 0.965, height: geo.size.height * 0.30)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding(.bottom, geo.size.height * 0.01)
                }
                .tag(0)
                
                TabWeekStatsView()
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
                    VStack {
                        Menu {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selectedOption = option // Met à jour la sélection
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
                    }
                    .padding(.top, geo.size.height * 0.05)
                }
            }
        }
    }
}

#Preview {
    DayStatsView(weekStats: .constant(false))
}
