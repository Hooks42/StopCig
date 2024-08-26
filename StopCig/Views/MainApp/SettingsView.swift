//
//  SettingsView.swift
//  StopCig
//
//  Created by Hook on 23/08/2024.
//

import SwiftUI

struct SettingsView: View {
     
    let pickerUnit :[Int] = SettingsView.fillPickerUnit()
    let pickerDec :[Int] = SettingsView.fillPickerDec()
    let pickerCigPerDay :[String:Int] = SettingsView.fillCigPerDay()
    
    @State var selectedOptionUnit = 0
    @State var selectedOptionDec = 0
    @State var selectedOptionCigPerDay : String?
    
    @Binding var smokerModel: SmokerModel?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Text("Réglages")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.bottom, geo.size.height * 0.45)
                VStack (spacing: 30) {
                    HStack {
                        Text("Prix du paquet")
                            .foregroundColor(.white)
                            .font(.custom("Quicksand-SemiBold", size: geo.size.width * 0.046))
                        Picker(selection: $selectedOptionUnit, label: Text("Select an option")) {
                            ForEach(0..<pickerUnit.count, id: \.self) { index in
                                Text(String(self.pickerUnit[index])).tag(index)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.15)
                        Text(".")
                            .foregroundColor(.white)
                            .font(.custom("Quicksand-SemiBold", size: geo.size.width * 0.046))
                            //.padding(.trailing, 50)
                        Picker("Select an Option ", selection: Binding(
                            get: { selectedOptionDec },
                            set: { selectedOptionDec = $0 }))
                        {
                            ForEach(0..<pickerDec.count, id: \.self) { index in
                                Text(String(self.pickerDec[index])).tag(index)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.15)
                        Text("€")
                            .foregroundColor(.white)
                            .font(.custom("Quicksand-SemiBold", size: geo.size.width * 0.046))
                    }
                    .padding(.top, geo.size.height * 0.15)
                    HStack (spacing: geo.size.width * 0.1){
                        Text("Conso")
                            .foregroundColor(.white)
                            .font(.custom("Quicksand-SemiBold", size: geo.size.width * 0.046))
                            .padding(.leading, geo.size.width * 0.1)
                        Picker("Nombre de cigarettes", selection: Binding(
                            get: { selectedOptionCigPerDay ?? "1 paquet" },
                            set: { selectedOptionCigPerDay = $0 }
                        )) {
                            let sortedCigaretTypes = pickerCigPerDay.sorted { $0.value < $1.value }
                            ForEach(sortedCigaretTypes, id: \.key) { key, value in
                                Text(key)
                                    .foregroundColor(.white)
                                    .tag(key)
                            }
                        }
                        .padding(.leading, geo.size.width * 0.09)
                        .pickerStyle(.inline)
                        .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.17)
                    }
                }
                .padding(.top, geo.size.height * 0.2)
            }
        }
        .onAppear() {
            if let smokerModel = smokerModel {
                selectedOptionUnit = Int(smokerModel.cigaretInfo.priceOfCigaret)
                selectedOptionDec = getDecimalPartAsInt(from: smokerModel.cigaretInfo.priceOfCigaret)
                selectedOptionCigPerDay = findKeyByVal(dictionnary: pickerCigPerDay, value: smokerModel.cigaretInfo.numberOfCigaretAnnounced)
                print("Price of cigarets : \(selectedOptionUnit) DEC : \(selectedOptionDec) AND cig per day : \(selectedOptionCigPerDay ?? "0")")
            }
            else {
                print("Error")
            }
        }
    }
    private static func fillPickerUnit() -> [Int] {
        var pickerUnit :[Int] = []
        for i in 0...30 {
            pickerUnit.append(i)
        }
        return pickerUnit
    }
    
    private static func fillPickerDec() -> [Int] {
        var pickerDec :[Int] = []
        for i in 0...95 {
            if i % 5 == 0 {
                pickerDec.append(i)
            }
        }
        return pickerDec
    }
    
    private static func fillCigPerDay() -> [String : Int] {
        
        var numberOfCigaretsSmoked : [String : Int] = [:]
        
        for i in 10...60 {
            switch i {
            case 20: numberOfCigaretsSmoked["1 paquet"] = i
            case 30: numberOfCigaretsSmoked["1 paquet et demi"] = i
            case 40: numberOfCigaretsSmoked["2 paquets"] = i
            case 50: numberOfCigaretsSmoked["2 paquets et demi"] = i
            case 60: numberOfCigaretsSmoked["3 paquets"] = i
            default: numberOfCigaretsSmoked["\(i) cigarettes"] = i
            }
        }
        return numberOfCigaretsSmoked
    }
}

#Preview {
    SettingsView(smokerModel: .constant(nil))
}
