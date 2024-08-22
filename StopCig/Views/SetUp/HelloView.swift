//
//  HelloView.swift
//  StopCig
//
//  Created by Hook on 26/07/2024.
//

import SwiftUI

struct HelloView: View {
    
    @State var showTitle = false
    @State var showText = false
    @State var showButton = false
    @Binding var isAcceptPressed: Bool
    
    var body: some View {
        VStack {
            if showTitle {
                Text("Bienvenue sur StopCig")
                    .foregroundColor(.white)
                    .font(.system(size: 48))
                    .bold()
                    .padding(.top, 100)
            }
            if showText {
                Text("Cette application est la pour t'aider à arrêter de fumer\nElle sera ton compagnon dans cette quette difficile qu'est le combat contre l'addiction")
                    .foregroundColor(.white)
                    .font(.custom("Quicksand-Light", size:20))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
            }
            Spacer()
            if showButton {
                Button(action: {
                    withAnimation(.easeInOut(duration: 1)) {
                        isAcceptPressed = true
                    }
                    }) {
                    Text("Je veux arrêter de fumer")
                        .foregroundColor(.black)
                        .font(.system(size: 28))
                        .bold()
                        .padding(40)
                        .background(
                            .white
                        )
                        .cornerRadius(20)
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                withAnimation(.easeInOut(duration: 1)){
                    showTitle.toggle()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                withAnimation(.easeInOut(duration: 1)){
                    showText.toggle()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                withAnimation(.easeInOut(duration: 1)){
                    showButton.toggle()
                }
            }
        }
    }
}

