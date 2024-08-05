import SwiftUI
import UIKit

struct OtherKindOfCigaretView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var smokerModel: SmokerModel?
    @Binding var textFieldForCigaret: Bool
    @Binding var isKindOfCigaretSelected: Bool
    @FocusState private var isFocused: Bool
    @State private var pricePhase = false
    @State private var selectedOtherCigaret = ""
    @State private var indication = "Inscris ta marque de cigarette"
    @State private var isKeyboardHidden = false
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }
            GeometryReader { geo in
                VStack {
                    Text(indication)
                        .font(.custom("Quicksand-Light", size: 22))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.15)
                    
                    TextField("", text: $selectedOtherCigaret)
                        .keyboardType(pricePhase ? .decimalPad : .default)
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .bold()
                        .frame(width: geo.size.width * 0.95, height: 30)
                        .multilineTextAlignment(.center)
                        .background(
                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5))
                                .frame(height: 30)
                                .cornerRadius(7)
                        )
                        .position(x: geo.size.width / 2, y: 0)
                    if !pricePhase {
                        Button(action: {
                            print("Cigarette choisie : \(selectedOtherCigaret)")
                            if smokerModel != nil && selectedOtherCigaret != "" {
                                smokerModel!.cigaretInfo.kindOfCigaret = selectedOtherCigaret
                                saveInSmokerDb(modelContext)
                                isFocused = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 1)){
                                        indication = "Quel est le prix d'un paquet ?"
                                        selectedOtherCigaret = ""
                                        pricePhase = true
                                    }
                                }
                            }
                        }) {
                            Text("Continuer")
                                .foregroundColor(.black)
                                .font(.system(size: 19))
                                .bold()
                                .padding(13)
                                .background(
                                    Color(.white)
                                )
                                .cornerRadius(20)
                        }
                    } else {
                        Button(action: {
                            selectedOtherCigaret = selectedOtherCigaret.replacingOccurrences(of: ",", with: ".")
                            if checkIfInputIsOk() {
                                if smokerModel != nil {
                                    smokerModel!.cigaretInfo.priceOfCigaret = Double(selectedOtherCigaret) ?? 0.0
                                    print("var = \(selectedOtherCigaret) | doubleCast = \(Double(selectedOtherCigaret) ?? 0.00) | in db = \(smokerModel!.cigaretInfo.priceOfCigaret)")
                                    saveInSmokerDb(modelContext)
                                    isFocused = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 1)){
                                            isKindOfCigaretSelected = true
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Continuer")
                                .foregroundColor(.black)
                                .font(.system(size: 19))
                                .bold()
                                .padding(13)
                                .background(
                                    Color(.white)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
    }
    
    private func checkIfInputIsOk() -> Bool {
        // Expression régulière pour les deux formats spécifiés
        let regex = "^[0-9]{2}([.,][0-9]{2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: selectedOtherCigaret)
    }
}
