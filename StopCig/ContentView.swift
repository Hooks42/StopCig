//
//  ContentView.swift
//  StopCig
//
//  Created by Hook on 24/07/2024.
//

import SwiftUI
import SwiftData
import AVKit
import Combine

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
    @State private var isRoutineSet = false
    
    
    @Query private var smokerModels: [SmokerModel]
    @State private var smokerModel: SmokerModel!
    
    @State private var currentDate: Date = Date()
    @State private var cancellable: AnyCancellable?
    
    @State private var test = ""
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showAlert = false
    
    
    var body: some View {
        ZStack {
            if smokerModel != nil && smokerModel.firstOpening {
                
                MainBoardView(smokerModel: $smokerModel)
                Text(test)
                    .foregroundColor(.white)
                    .font(.system(size: 70))
                Button(action: {
                    self.updateCurrentDateTime()
                }) {
                    Text("Update")
                        .foregroundColor(.white)
                        .font(.system(size: 70))
                        .position(x: 200, y: 750)
                }
            }
            if smokerModel != nil && !smokerModel!.firstOpening {
                PlayerView(videoName: "Smoke")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if !isAcceptPressed {
                        HelloView(isAcceptPressed: $isAcceptPressed)
                    }
                }
                VStack {
                    if isAcceptPressed && smokerModel != nil && !isKindOfCigaretSelected {
                        WhatKindOfCigaretsView(smokerModel: $smokerModel, isKindOfCigaretSelected: $isKindOfCigaretSelected)
                    }
                    if isKindOfCigaretSelected {
                        //Text("\(smokerModel!.cigaretInfo.kindOfCigaret) sélectionnée avec pour prix : \(smokerModel!.cigaretInfo.priceOfCigaret) €")
                    }
                }
                VStack {
                    if isAcceptPressed && isKindOfCigaretSelected && !isRoutineSet && smokerModel != nil {
                        HowManyCigaretsSmokedView(smokerModel: $smokerModel, isRoutineSet: $isRoutineSet)
                    }
                    if isRoutineSet {
                        MainBoardView(smokerModel: $smokerModel)
                    }
                }
            }
        }
        .onAppear() {
            initializeSmokerModel()
            cancellable = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
                .sink { _ in
                    self.updateCurrentDateTime()
                }
            self.updateCurrentDateTime()
        }
    }
    
    private func initializeSmokerModel(){
        if smokerModels.isEmpty {
            let newSmokerModel = SmokerModel(
                firstOpening: false,
                cigaretInfo: CigaretInfos(kindOfCigaret: "", priceOfCigaret: 0.0, numberOfCigaretAnnounced: 0),
                cigaretCountThisDay: CigaretCountThisDay(cigaretSmoked: 0, cigaretSaved: 0, gain: 0, lost: 0),
                cigaretTotalCount: CigaretTotalCount(cigaretSmoked: 0, cigaretSaved: 0, gain: 0, lost: 0),
                numberOfCigaretProgrammedThisDay: 0,
                daySinceFirstOpening: 0,
                needToReset: false,
                lastOpening: Date()
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
    
    private func updateCurrentDateTime() {
        // Si un seul param et que c'est une closure pas besoin de () apres l'appel
        print("App is back in the foreground, fetching current date and time\n\n")
        fetchCurrentDate { date in
            if let date = date {
                DispatchQueue.main.async {
                    self.currentDate = date
                    self.test = date.description
                    print("App is back in the foreground, current date and time updated: \(self.currentDate)")
                }
            } else {
                print("error")
            }
        }
    }
    
    private func fetchCurrentDate(completion: @escaping (Date?) -> Void) {
        // On Creer une url vers le bon endpoint et on regarde si l'url est valide
        guard let url = URL(string: "https://timeapi.io/api/time/current/zone?timeZone=Europe%2FParis") else {
            completion(nil)
            print("url not valid)")
            return
        }
        // On lance une requete GET avec URLSession.shared.dataTask qui recupere trois parametres
        // Le contenu du json, le code d'erreur ex:404, et l'objet erreur si il y en a une
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                print("something went wrong")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON reçu : \(jsonString)")
                }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code : \(httpResponse.statusCode)")
            }
            
            // On parse le json pour recuperer la date et on la retourne
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                   let dateTimeString = json["dateTime"] as? String {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Sert a convertir la date en UTC ce qui est le format de la date recu par l'api
                    if let date = dateFormatter.date(from: dateTimeString) {
                        completion(date)
                    } else {
                        print("error parsing date")
                        completion(nil)
                    }
                } else {
                    print("error parsing json else")
                    completion(nil)
                }
            } catch {
                print("error parsing json catch")
                completion(nil)
            }
        }.resume() // Fonctionne comme un .start() pour lancer la requete les lignes au dessus sont la config avant de start
    }
}
    
    #Preview {
        ContentView()
            .modelContainer(for: SmokerModel.self, inMemory: true)
    }
