//
//  WeekStatsView.swift
//  StopCig
//
//  Created by Hook on 03/10/2024.
//

import SwiftUI
import Charts

struct WeekStatsView: View {
    @State private var selectedOption = "Argent économisé"
    let options = ["Argent économisé", "Argent perdu", "Cigarettes sauvées", "Cigarettes fumées"]
    
    let data = [
        ("1", 10),
        ("2", 13),
        ("3", 09),
        ("4", 11),
        ("5", 13),
        
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    Text("Hebdomadaire")
//                        .font(.custom("Quicksand-SemiBold", size: 30))
//                        .foregroundColor(.white)
//                }
//                .padding(.bottom, geo.size.height * 0.90)
//                .padding(.trailing, geo.size.width * 0.29)
//                VStack {
//                    Menu {
//                        ForEach(options, id: \.self) { option in
//                            Button(action: {
//                                selectedOption = option // Met à jour la sélection
//                            }) {
//                                Text(option)
//                            }
//                        }
//                    } label: {
//                        Text(self.selectedOption)
//                            .font(.custom("Quicksand-SemiBold", size: 20))
//                            .padding(20)
//                            .foregroundColor(.white)
//                            .background(
//                                RoundedRectangle(cornerRadius: 40)
//                                    .stroke(Color(.myYellow), lineWidth: 2)
//                                    .fill(Color(.clear))
//                            )
//                            
//                    }
//                }
//               .padding(.bottom, geo.size.height * 0.60)
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
        }
    }
}

#Preview {
    WeekStatsView()
}
