import SwiftUI

struct HowManyCigaretsSmokedView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var smokerModel: SmokerModel?
    @Binding var isRoutineSet: Bool
    
    @State private var questionForRoutine = false
    @State private var pickerForRoutine = false
    @State private var buttonForRoutine = false
    @State private var numberOfCigaretsSmoked : [String : Int] = HowManyCigaretsSmokedView.fillArray()
    @State private var selectedRoutine : String = "10 cigarettes"
    
    var body: some View {
        ZStack {
        GeometryReader { geo in
            VStack {
                if questionForRoutine {
                    VStack {
                        Text("Combien en fumes-tu par jour ?")
                            .font(.custom("Quicksand-Light", size: 22))
                            .foregroundColor(.white)
                        Text("( Si tu ne sais pas compte et reviens demain ! )")
                            .font(.custom("Quicksand-Light", size: 12))
                            .foregroundColor(.white)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.15)
                }
                if pickerForRoutine {
                    Picker("Nombre de cigarettes", selection: $selectedRoutine) {
                        let sortedCigaretTypes = numberOfCigaretsSmoked.sorted { $0.value < $1.value }
                        ForEach(sortedCigaretTypes, id: \.key) { key, value in
                            Text(key)
                                .foregroundColor(.white)
                                .tag(key)
                        }
                    }
                    .pickerStyle(.inline)
                    .position(x: geo.size.width / 2, y: 0)
                }
                
                if buttonForRoutine {
                    Button(action : {
                        print("Routine got value : \(selectedRoutine)")
                        if !selectedRoutine.isEmpty && smokerModel != nil {
                            smokerModel!.cigaretInfo.numberOfCigaretAnnounced = numberOfCigaretsSmoked[selectedRoutine] ?? 0
                            initDB()
                            saveInSmokerDb(modelContext)
                            print("Routine set with value : \(smokerModel!.cigaretInfo.numberOfCigaretAnnounced)")
                            isRoutineSet = true
                        }
                    }) {
                        Text("Continuer")
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
            }
            
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1)){
                        questionForRoutine = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 1)){
                        pickerForRoutine = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)){
                        buttonForRoutine = true
                    }
                }
            }
        }
    }
}
    static private func fillArray() -> [String : Int] {
        
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
    
    private func initDB() {
        if smokerModel != nil {
            smokerModel!.firstOpening = true
            smokerModel!.numberOfCigaretProgrammedThisDay = Int(Double(numberOfCigaretsSmoked[selectedRoutine] ?? 0) - Double((numberOfCigaretsSmoked[selectedRoutine] ?? 0)) * 0.2)
            smokerModel!.cigaretTotalCount.gain = smokerModel!.cigaretInfo.priceOfCigaret / 20 * Double(smokerModel!.numberOfCigaretProgrammedThisDay)
        }
    }
}

#Preview {
    HowManyCigaretsSmokedView(smokerModel: .constant(nil), isRoutineSet: .constant(false))
}
