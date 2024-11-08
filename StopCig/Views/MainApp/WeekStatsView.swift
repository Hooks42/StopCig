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
    @Binding var smokerModel : SmokerModel?
    @Binding var pickedValue : String
    @Binding var noData: Bool

    var prepareDataFunction : (Bool) -> [graphDataStruct]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    let data = prepareDataFunction(false)
                    if !data.isEmpty {
                        Chart {
                            ForEach(data, id: \.index) { item in
                                BarMark (
                                    x: .value("Index", item.index),
                                    y: .value("Valeur", item.value)
                                )
                                .foregroundStyle(.myYellow)
                            }
                        }
                        .frame(width: geo.size.width * 0.965, height: geo.size.height * 0.30)
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisTick()
                                AxisValueLabel()
                                
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
                                                    let newValue = getInfosByIndexInGraphData(model: smokerModel, index: index, selectedOption: self.selectedOption, isDay: false)
                                                    if (newValue != self.pickedValue) {
                                                        self.pickedValue = newValue
                                                    }
                                                }
                                            }
                                    )
                            }
                        }
                    } else {
                        if !self.noData {
                            Text("Aucune Donnée disponible !")
                                .foregroundColor(.white)
                                .font(.custom("Quicksand-SemiBold", size: 20))
                        }
                    }
                }
                .padding(.bottom, geo.size.height * 0.01)
            }
        }
    }
}
