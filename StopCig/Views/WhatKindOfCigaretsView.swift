import SwiftUI

struct CigaretType: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var price: Float
}

struct WhatKindOfCigaretsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var smokerModel: SmokerModel?
    @Binding var isKindOfCigaretSelected: Bool
    
    @State var questionForCigaret = false
    @State var pickerForCigaret = false
    @State var buttonForCigaret = false
    @State var cigaretsMap = WhatKindOfCigaretsView.createCigaretMap()
    @State var selectedCigaret : CigaretType? = WhatKindOfCigaretsView.createCigaretMap().first
    @State var textFieldForCigaret = false
    
    //@State var testMessage = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if questionForCigaret {
                    Text("Choisis ta marque de cigarette")
                        .font(.custom("Quicksand-Light", size: 22))
                        .foregroundColor(.white)
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.15)
                }
                if pickerForCigaret {
                    Picker(selection: $selectedCigaret, label: Text("Marque de cigarette")) {
                        ForEach(self.cigaretsMap) { item in
                            Text(item.name)
                                .foregroundColor(.white)
                                .tag(item as CigaretType?)
                        }
                    }
                    .pickerStyle(.inline)
                    .position(x: geo.size.width / 2, y: 0)
                }
                if textFieldForCigaret {
                    OtherKindOfCigaretView(smokerModel: $smokerModel, textFieldForCigaret: $textFieldForCigaret, isKindOfCigaretSelected: $isKindOfCigaretSelected)
                }
                if buttonForCigaret {
                    Button(action: {
                        if let selected = selectedCigaret {
                            print("Cigarette choisie : \(selected.name)")
                            if smokerModel != nil && selected.name != "Autres" {
                                smokerModel!.cigaretInfo.kindOfCigaret = selected.name
                                smokerModel!.cigaretInfo.priceOfCigaret = Double(selected.price)
                                withAnimation(.easeInOut(duration: 1)){
                                    isKindOfCigaretSelected = true                            }
                                saveInSmokerDb(modelContext)
                            } else {
                                if selected.name == "Autres" {
                                    withAnimation(.easeInOut(duration: 1)){
                                        questionForCigaret = false
                                        pickerForCigaret = false
                                        buttonForCigaret = false
                                        textFieldForCigaret = true
                                    }
                                }
                                print("Aucune cigarette choisie")
                            }
                            print(smokerModel!.cigaretInfo.kindOfCigaret + "and" + String(smokerModel!.cigaretInfo.priceOfCigaret))
                        }
                    }) {
                        Text("Je Choisis")
                            .foregroundColor(.black)
                            .font(.system(size: 19))
                            .padding(13)
                            .bold()
                            .background(
                                Color(.white)
                            )
                            .cornerRadius(20)
                    }
                }
                //            Button(action: {
                //                testMessage.toggle()
                //            }) {
                //                if !testMessage {
                //                    Text("Test")
                //                        .foregroundColor(.black)
                //                        .font(.system(size: 19))
                //                        .bold()
                //                        .padding(13)
                //                        .background(
                //                            Color(.white)
                //                        )
                //                        .cornerRadius(20)
                //                } else {
                //                    Text("la cigarette en memoire est : \(smokerModel!.cigaretInfo.kindOfCigaret)")
                //                        .foregroundColor(.black)
                //                        .font(.system(size: 19))
                //                        .bold()
                //                        .padding(13)
                //                        .background(
                //                            Color(.white)
                //                        )
                //                        .cornerRadius(20)
                //                }
                //
                //            }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                withAnimation(.easeInOut(duration: 1)){
                    questionForCigaret.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                withAnimation(.easeInOut(duration: 1)){
                    pickerForCigaret.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                withAnimation(.easeInOut(duration: 1)){
                    buttonForCigaret.toggle()
                }
            }
        }
    }
    
    func printitem(any: Any) {
        print(any)
    }
    
    static func createCigaretMap() -> [CigaretType] {
        let cigarets = [
            CigaretType(name: "Marlboro Red", price: 12.5),
            CigaretType(name: "Malboro Gold", price: 12.5),
            CigaretType(name: "Vogue", price: 12),
            CigaretType(name: "JPS", price: 12),
            CigaretType(name: "Chesterfield", price: 12),
            CigaretType(name: "Philip Morris", price: 12),
            CigaretType(name: "Lucky Strike", price: 11.5),
            CigaretType(name: "Winfield", price: 11.5),
            CigaretType(name: "Winston", price: 12),
            CigaretType(name: "Winston Blue", price: 12),
            CigaretType(name: "Winston Classic", price: 12),
            CigaretType(name: "Camel", price: 11.5),
            CigaretType(name: "Rothmans", price: 11.5),
            CigaretType(name: "Austin Fresh", price: 10.9),
            CigaretType(name: "Elixyr Fresh", price: 10.9),
            CigaretType(name: "Mademoiselle Fresh", price: 10.9),
            CigaretType(name: "Autres", price: 0),
        ]
        return cigarets
    }
}


#Preview {
    WhatKindOfCigaretsView(smokerModel: .constant(nil), isKindOfCigaretSelected: .constant(false))
}
