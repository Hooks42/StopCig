//
//  BofValidationView.swift
//  StopCig
//
//  Created by Hook on 20/11/2024.
//

import SwiftUI

struct BofValidationView: View {
    @Binding    var smokerModel : SmokerModel?
    @Binding    var isSheetPresented : Bool
    @Binding    var showWeekFeelingsView: Bool
    @State      var oldCigaretsPerDay = 0
    @State      var weekAdvice = "le paquet"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.nightBlue
                    .edgesIgnoringSafeArea(.all)
                Text("C'est bien !")
                    .font(.custom("Quicksand-SemiBold", size: 40))
                    .foregroundColor(.white)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.08)
                Text("Tu peux être fier de toi, tu progresses dans ton objectif d'arrêter de fumer !\nC'est normal de craquer parfois ou de se sentir un peu découragé mais c'est en passant par là que tu vas y arriver Courage !")
                    .font(.custom("Quicksand-Light", size: 18))
                    .frame(width: geo.size.width * 0.93)
                    .foregroundColor(.white)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.25)
                Text("Cette semaine tes objectifs seront :")
                    .font(.custom("Quicksand-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .offset(y: -(geo.size.height * 0.05))
                VStack {
                    HStack {
                        Image("checkBullet")
                            .resizable()
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                        Text("Rester sur le même rythme que la semaine précédente mais sans écart cette fois")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.08)
                    
                    
                    HStack {
                        Image("checkBullet")
                            .resizable()
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                        Text("Ne pas te laisser tenter par les cigarettes plaisir uniquement les essentielles")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.11)
                    
                    
                    HStack {
                        Image("checkBullet")
                            .resizable()
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                        Text("Mettre uniquement tes \(self.oldCigaretsPerDay) cigarettes directement dans \(self.weekAdvice) pour ne pas être tenté")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.14)
                    
                    SlideToAcceptView(isSheetPresented: $isSheetPresented, showWeekFeelingsView: $showWeekFeelingsView, newCigaretsPerDay: $oldCigaretsPerDay, smokerModel: $smokerModel)
                        .offset(y: geo.size.height * 0.27)
                    
                }
                .offset(y: geo.size.height * 0.45)
            }
            .onAppear() {
                self.oldCigaretsPerDay = smokerModel?.numberOfCigaretProgrammedThisDay ?? 0
                if (self.oldCigaretsPerDay > 20) {
                    self.weekAdvice = "les paquets"
                }
            }
        }
    }
}

#Preview {
    BofValidationView(smokerModel: .constant(nil), isSheetPresented: .constant(true), showWeekFeelingsView: .constant(true))
}
