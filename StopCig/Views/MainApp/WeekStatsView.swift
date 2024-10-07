//
//  WeekStatsView.swift
//  StopCig
//
//  Created by Hook on 03/10/2024.
//

import SwiftUI
import Charts

struct WeekStatsView: View {
    @Binding var selectedOption : String
    @Binding var graphData : [String : [(String, Int)]]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Chart {
                        if let data = graphData["W" + selectedOption] {
                            ForEach(data, id: \.0) { item in
                                BarMark (
                                    x: .value("Jour", item.0),
                                    y: .value("Valeur", item.1)
                                )
                                .foregroundStyle(.myYellow)
                                
                            }
                        }
                    }
                    .frame(width: geo.size.width * 0.965, height: geo.size.height * 0.30)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
                .padding(.bottom, geo.size.height * 0.01)
            }
        }
    }
}
