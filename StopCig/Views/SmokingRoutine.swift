////
////  SmokingRoutine.swift
////  StopCig
////
////  Created by Hook on 29/07/2024.
////
//
//import SwiftUI
//
//struct SmokingRoutine: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    @Binding var smokerModel: SmokerModel?
//    @Binding var isSmokingRoutineSelected: Bool
//    
//    @State var questionForRoutine = false
//    @State var pickerForRoutine = false
//    @State var ButtonForRoutine = false
//    @State var cigaretsMap = WhatKindOfCigaretsView.createCigaretMap()
//    //@State private var selectedCigaret : CigaretType? = WhatKindOfCigaretsView.createCigaretMap().first
//    
//    //@State var testMessage = false
//    
//    var body: some View {
//        VStack {
//            if questionForRoutine {
//                Text("Combien de cigarette fumes-tu par jour ?")
//                    .font(.custom("Quicksand-Light", size: 22))
//                    .foregroundColor(.white)
//                    .padding(.bottom, 150)
//            }
//            if pickerForRoutine {
//                Picker(selection: $selectedCigaret, label: Text("Marque de cigarette")) {
//                    ForEach(self.cigaretsMap) { item in
//                        Text(item.name).tag(item as CigaretType?)
//                    }
//                }
//                .pickerStyle(.inline)
//                .foregroundColor(.white)
//                .padding(.bottom, 200)
//            }
//            if ButtonForCigaret {
//                Button(action: {
//                    if let selected = selectedCigaret {
//                        print("Cigarette choisie : \(selected.name)")
//                        if smokerModel != nil {
//                            smokerModel!.cigaretInfo.kindOfCigaret = selected.name
//                            smokerModel!.cigaretInfo.priceOfCigaret = selected.price
//                            isKindOfCigaretSelected = true
//                            do {
//                                try modelContext.save()
//                            } catch {
//                                print("Error saving context")
//                            }
//                        } else {
//                            print("Aucune cigarette choisie")
//                        }
//                        print(smokerModel!.cigaretInfo.kindOfCigaret + "and" + String(smokerModel!.cigaretInfo.priceOfCigaret))
//                    }
//                }) {
//                    Text("Je Choisis")
//                        .foregroundColor(.black)
//                        .font(.system(size: 19))
//                        .bold()
//                        .padding(13)
//                        .background(
//                            Color(.white)
//                        )
//                        .cornerRadius(20)
//                }
//            }
////            Button(action: {
////                testMessage.toggle()
////            }) {
////                if !testMessage {
////                    Text("Test")
////                        .foregroundColor(.black)
////                        .font(.system(size: 19))
////                        .bold()
////                        .padding(13)
////                        .background(
////                            Color(.white)
////                        )
////                        .cornerRadius(20)
////                } else {
////                    Text("la cigarette en memoire est : \(smokerModel!.cigaretInfo.kindOfCigaret)")
////                        .foregroundColor(.black)
////                        .font(.system(size: 19))
////                        .bold()
////                        .padding(13)
////                        .background(
////                            Color(.white)
////                        )
////                        .cornerRadius(20)
////                }
////
////            }
//        }
//        .onAppear() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                withAnimation(.easeInOut(duration: 1)){
//                    questionForCigaret.toggle()
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
//                withAnimation(.easeInOut(duration: 1)){
//                    pickerForCigaret.toggle()
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//                withAnimation(.easeInOut(duration: 1)){
//                    ButtonForCigaret.toggle()
//                }
//            }
//        }
//    }
//    
//    func printitem(any: Any) {
//        print(any)
//    }
//    
//    static func createCigaretMap() -> [CigaretType] {
//        let cigarets = [
//            CigaretType(name: "Marlboro Red", price: 12.5),
//            CigaretType(name: "Malboro Gold", price: 12.5),
//            CigaretType(name: "Vogue", price: 12),
//            CigaretType(name: "JPS", price: 12),
//            CigaretType(name: "Chesterfield", price: 12),
//            CigaretType(name: "Philip Morris", price: 12),
//            CigaretType(name: "Lucky Strike", price: 11.5),
//            CigaretType(name: "Winfield", price: 11.5),
//            CigaretType(name: "Winston", price: 12),
//            CigaretType(name: "Winston Blue", price: 12),
//            CigaretType(name: "Winston Classic", price: 12),
//            CigaretType(name: "Camel", price: 11.5),
//            CigaretType(name: "Rothmans", price: 11.5),
//            CigaretType(name: "Austin Fresh", price: 10.9),
//            CigaretType(name: "Elixyr Fresh", price: 10.9),
//            CigaretType(name: "Mademoiselle Fresh", price: 10.9),
//            CigaretType(name: "Autres", price: 0),
//        ]
//        return cigarets
//    }
//}
