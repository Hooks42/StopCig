//
//  DurValidationView.swift
//  StopCig
//
//  Created by Hook on 20/11/2024.
//

import SwiftUI

struct DurValidationView: View {
    @Binding    var smokerModel : SmokerModel?
    @Binding    var isSheetPresented : Bool
    @State      var oldCigaretsPerDay = 0
    @State      var newCigaretsPerDay = 0
    @State      var weekAdvice = "le paquet"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.nightBlue
                    .edgesIgnoringSafeArea(.all)
                Text("Tout va bien !")
                    .font(.custom("Quicksand-SemiBold", size: 40))
                    .foregroundColor(.white)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.08)
                Text("Les moments compliqués sont temporaires, mais tes victoires sans tabac resteront. Tu es sur le bon chemin !\nPrends soin de toi, sois indulgent : tu avances, et c’est ce qui compte !")
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
                        Text("Si cette semaine était dure peut être que l'objectif était trop haut nous allons l'augmenter un peu")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.08)
                    
                    
                    HStack {
                        Image("checkBullet")
                            .resizable()
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                        Text("Ta consommation passera de \(self.oldCigaretsPerDay) à \(self.newCigaretsPerDay) cigarettes\npar jour")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.11)
                    
                    
                    HStack {
                        Image("checkBullet")
                            .resizable()
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                        Text("Mettre uniquement tes \(self.newCigaretsPerDay) cigarettes directement dans \(self.weekAdvice) pour ne pas être tenté")
                            .font(.custom("Quicksand-Light", size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: geo.size.width * 0.94, alignment: .leading)
                    .offset(x: geo.size.width * 0.02, y: geo.size.height * 0.14)
                    
                    SlideToAcceptView(isSheetPresented: $isSheetPresented)
                        .offset(y: geo.size.height * 0.29)
                    
                }
                .offset(y: geo.size.height * 0.42)
            }
            .onAppear() {
                self.oldCigaretsPerDay = smokerModel?.numberOfCigaretProgrammedThisDay ?? 0
                self.newCigaretsPerDay = Int(Double(smokerModel?.numberOfCigaretProgrammedThisDay ?? 0) + Double(smokerModel?.numberOfCigaretProgrammedThisDay ?? 0) * 0.1)
                if (self.newCigaretsPerDay > 20) {
                    self.weekAdvice = "les paquets"
                }
            }
        }
    }
}

#Preview {
    DurValidationView(smokerModel: .constant(nil), isSheetPresented: .constant(true))
}
