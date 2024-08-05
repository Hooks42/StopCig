//
//  ContentView.swift
//  StopCig
//
//  Created by Hook on 24/07/2024.
//

import SwiftUI
import SwiftData
import AVKit

// UIViewRepresentable permet intégrer une UIView dans SwiftUI car AVKit est basé sur UIKit

struct PlayerView: UIViewRepresentable {
    var videoName: String
    
// L'initialisateur permet de creer une instance de playerView en initialisant videoName
    init(videoName: String){
        self.videoName = videoName
    }

// Cette méthode est requise par le protocole UIViewRepresentable. Elle est appelée pour mettre à jour la vue UIKit lorsque les données SwiftUI changent. Dans ce cas, elle est vide car aucune mise à jour n'est nécessaire.
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
// Cette méthode crée et retourne une instance de UIView. Ici, elle retourne une instance de VideoBackgroundView initialisée avec le nom de la vidéo. VideoBackgroundView est probablement une sous-classe de UIView qui gère l'affichage de la vidéo.
    func makeUIView(context: Context) -> UIView {
        return VideoBackgroundView(videoName: videoName)
    }
}

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var isAcceptPressed = false
    @State private var isKindOfCigaretSelected = false
    
    @Query private var smokerModels: [SmokerModel]
    @State private var smokerModel: SmokerModel!
    
    
    var body: some View {
        ZStack {
            PlayerView(videoName: "Smoke")
                .edgesIgnoringSafeArea(.all)
            if smokerModel != nil && !smokerModel!.firstOpening {
                VStack {
                    Text("cigaret = \(smokerModel!.cigaretInfo.kindOfCigaret) AND price = \(smokerModel!.cigaretInfo.priceOfCigaret)")
                        .position(x: 200, y: 0)
                    if !isAcceptPressed {
                        HelloView(isAcceptPressed: $isAcceptPressed)
                    }
                }
                VStack {
                    if isAcceptPressed && smokerModel != nil && !isKindOfCigaretSelected {
                        WhatKindOfCigaretsView(smokerModel: $smokerModel, isKindOfCigaretSelected: $isKindOfCigaretSelected)
                    }
                    if isKindOfCigaretSelected {
                        Text("\(smokerModel!.cigaretInfo.kindOfCigaret) sélectionnée avec pour prix : \(smokerModel!.cigaretInfo.priceOfCigaret) €")
                    }
                }
            } else {
                Text("Already initialized")
        }
    }
        .onAppear() {
            initializeSmokerModel()
        }
    }
    
    private func initializeSmokerModel(){
        if smokerModels.isEmpty {
            let newSmokerModel = SmokerModel(
                firstOpening: false,
                cigaretInfo: CigaretInfos(kindOfCigaret: "", priceOfCigaret: 0.0, numberOfCigaretAnnounced: 0),
                numberOfCigaretProgrammedThisDay: 0,
                cigaretSmoked: CigaretCount(thisDay: 0, thisWeek: 0, thisMonth: 0),
                cigaretSaved: CigaretCount(thisDay: 0, thisWeek: 0, thisMonth: 0)
            )
            modelContext.insert(newSmokerModel)
            do {
                try modelContext.save()
            } catch {
                print("db already initialized")
            }
        }
        smokerModel = smokerModels.first
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SmokerModel.self, inMemory: true)
}
