//
//  SettingsView.swift
//  StopCig
//
//  Created by Hook on 23/08/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var smokerModel: SmokerModel?
    @Binding var isSheetPresented: Bool
    
    @State var packPriceUnit : Int = 0
    @State var packPriceDecimal : Int = 0
    @State var pickerUnit : [Int] = Array(0...30)
    @State var pickerDecimal : [Int] = []
    @State var pickerWeekObjective : [Int]  = []
    @State var pickerUnitChoice : Int = 0
    @State var pickerDecimalChoice : Int = 0
    @State var pickerObjectiveChoice : Int = 0
    
    @State var newPrice : Double = 0
    @State var newObjective : Int = 0
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.nightBlue)
                    .edgesIgnoringSafeArea(.all)
                Text("Réglages")
                    .font(.custom("Quicksand-SemiBold", size: 40))
                    .foregroundColor(.white)
                    .offset(x: -(geo.size.width * 0.20), y: -(geo.size.height * 0.43))
                VStack (spacing: geo.size.height * 0.1) {
                    VStack {
                        Text("Prix du paquet :")
                            .font(.custom("Quicksand-SemiBold", size: 20))
                            .foregroundColor(.white)
                        HStack {
                            Picker(selection: $pickerUnitChoice, label: Text("Unité")) {
                                ForEach(0..<self.pickerUnit.count, id:\.self) { index in
                                    Text("\(pickerUnit[index])")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.2)
                            .onChange(of: pickerUnitChoice) {
                                self.newPrice = Double(pickerUnitChoice) + Double(pickerDecimalChoice) / 100
                            }
                            
                            Text(".")
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .foregroundColor(.white)
                            
                            Picker(selection: $pickerDecimalChoice, label: Text("Décimal")) {
                                ForEach(0..<self.pickerDecimal.count, id:\.self) { index in
                                    Text("\(pickerDecimal[index])")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.2)
                            .onChange(of: pickerDecimalChoice) {
                                self.newPrice = Double(pickerUnitChoice) + Double(pickerDecimalChoice) / 100
                            }
                            
                            Text("€")
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack {
                        Text("Objectif de la semaine:")
                            .font(.custom("Quicksand-SemiBold", size: 20))
                            .foregroundColor(.white)
                        HStack {
                            Picker(selection: $pickerObjectiveChoice, label: Text("Objectif")) {
                                ForEach(0..<self.pickerWeekObjective.count, id:\.self) { index in
                                    Text("\(pickerWeekObjective[index])")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.2)
                            .onChange(of: pickerObjectiveChoice) {
                                self.newObjective = pickerObjectiveChoice
                            }
                            
                            Text("cigarettes")
                                .font(.custom("Quicksand-SemiBold", size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                SlideToSaveSettingsView(smokerModel: $smokerModel, isSheetPresented: $isSheetPresented, newPrice: $newPrice, newObjective: $newObjective)
                    .offset(y: geo.size.height * 0.9)
            }
            .onAppear() {
                self.fillDecPicker()
                self.fillWeekObjectivePicker()
                let packPrice = smokerModel?.cigaretInfo.priceOfCigaret ?? 0
                self.pickerUnitChoice = Int(packPrice)
                self.pickerDecimalChoice = getDecimalPartAsInt(from: packPrice) / 5
                self.pickerObjectiveChoice = smokerModel?.numberOfCigaretProgrammedThisDay ?? 0
                self.newPrice = packPrice
                self.newObjective = self.pickerObjectiveChoice
            }
        }
    }
    
    private func fillDecPicker() {
        var i = 0
        while i <= 95 {
            pickerDecimal.append(i)
            i += 5
        }
    }
    
    private func fillWeekObjectivePicker() {
        let i = self.smokerModel?.cigaretInfo.numberOfCigaretAnnounced ?? 0
        if i > 0 {
            var index = 0
            while index <= i {
                self.pickerWeekObjective.append(index)
                index += 1
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.nightBlue)
            .edgesIgnoringSafeArea(.all)
        SettingsView(smokerModel: .constant(nil), isSheetPresented: .constant(true))
    }
}
