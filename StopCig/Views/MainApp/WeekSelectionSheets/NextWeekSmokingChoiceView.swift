//
//  NextWeekSmokingChoiceView.swift
//  StopCig
//
//  Created by Hook on 20/11/2024.
//

import SwiftUI

fileprivate struct ButtonStruct: View {
    
    let text : String
    let multiplier : Double
    
    @Binding var oldCigaretsPerDay : Int
    @Binding var newCigaretsPerDay : Int
    @Binding var isPresented : Bool
    @Binding var newCigaretsPercent : Int
    
    @State var newObjective = 0
    
    var body : some View {
        Button(action: {
            self.newCigaretsPerDay = self.newObjective
            self.isPresented = false
            switch self.multiplier {
                case 0.1:
                    self.newCigaretsPercent = 10
                case 0.15:
                    self.newCigaretsPercent = 15
                case 0.25:
                    self.newCigaretsPercent = 25
                default:
                    self.newCigaretsPercent = 20
            }
                
        }) {
            VStack (spacing: -5){
                Text(text)
                    .font(.custom("Quicksand-SemiBold", size: 20))
                    .foregroundColor(.black)
                    .padding()
                Text("\(oldCigaretsPerDay) -> \(self.newObjective)")
                    .font(.custom("Quicksand-SemiBold", size: 15))
                    .foregroundColor(.black)
            }
            .padding()
            .background(.white)
            .cornerRadius(30)
        }
        .onAppear() {
            self.newObjective = Int(Double(self.oldCigaretsPerDay) * (1 - self.multiplier))
        }
    }
}

struct NextWeekSmokingChoiceView: View {
    
    @Binding var oldCigaretsPerDay : Int
    @Binding var newCigaretsPerDay : Int
    @Binding var isPresented : Bool
    @Binding var newCigaretsPercent : Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.nightBlue
                    .edgesIgnoringSafeArea(.all)
                VStack (spacing: 100) {
                    Text("Un objectif personalisé cette semaine ?")
                        .font(.custom("Quicksand-SemiBold", size: 25))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geo.size.width * 0.9, alignment: .center)
                    HStack {
                        ButtonStruct(text: "10 %", multiplier: 0.1, oldCigaretsPerDay: self.$oldCigaretsPerDay, newCigaretsPerDay: self.$newCigaretsPerDay, isPresented: self.$isPresented, newCigaretsPercent: self.$newCigaretsPercent)
                        ButtonStruct(text: "15 %", multiplier: 0.15, oldCigaretsPerDay: self.$oldCigaretsPerDay, newCigaretsPerDay: self.$newCigaretsPerDay, isPresented: self.$isPresented, newCigaretsPercent: self.$newCigaretsPercent)
                        ButtonStruct(text: "25 %", multiplier: 0.25, oldCigaretsPerDay: self.$oldCigaretsPerDay, newCigaretsPerDay: self.$newCigaretsPerDay, isPresented: self.$isPresented, newCigaretsPercent: self.$newCigaretsPercent)
                    }
                }
            }
        }
    }
}

#Preview {
    NextWeekSmokingChoiceView(oldCigaretsPerDay: .constant(20), newCigaretsPerDay: .constant(16), isPresented: .constant(true), newCigaretsPercent: .constant(0))
}
