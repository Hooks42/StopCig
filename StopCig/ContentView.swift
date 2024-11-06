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
    
    // Var pour les vues de démarage de l'app
    @State private var isAcceptPressed = false
    @State private var isKindOfCigaretSelected = false
    @State private var isRoutineSet = false
    
    // Var pour les tests
    @State private var startTest = true
    @State private var test = ""
    
    // Var pour le model SwiftData
    @Query private var smokerModels: [SmokerModel]
    @State private var smokerModel: SmokerModel!
    
    // Var pour la mise a jour des variables sur le fetch du temps
    @State private var currentDate: Date = Date()
    @State private var cancellable: AnyCancellable?
    @State var needToReset = false
    
    // Var pour check si l'utilisateur est connecté a internet
    @StateObject private var networkMonitor = NetworkMonitor() // un StateObject sert a creer un object persistant dans toute l'application
    
    // Var pour les settings
    @State private var showAlert = false
    
    // Var pour l'index du tabView
    @State private var indexTabView = 0
    @State private var weekStats = false
    
    @State private var addDay = false
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if smokerModel != nil && smokerModel.firstOpening ||  isRoutineSet {
                    TabView(selection: $indexTabView)
                    {
                        MainMenuView(smokerModel: $smokerModel, needToReset: $needToReset, startTest: $startTest, addDay: $addDay, updateCurrentDateTime: updateCurrentDateTime)
                            .tabItem { Text("Menu 1") }
                            .tag(0)
                        
                        ToDayStatsView(smokerModel: $smokerModel, weekStats: $weekStats)
                            .tabItem { Text("Menu 2") }
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .ignoresSafeArea()
                    ZStack {
                        DotView(indexTabView: $indexTabView, weekStats: $weekStats)
                            .padding(.top, geo.size.height * 0.8)
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
                            HowManyCigaretsSmokedView(smokerModel: $smokerModel, isRoutineSet: $isRoutineSet, currentDate: $currentDate)
                        }
                    }
                }
            }
            .onAppear() {
                initializeSmokerModel()
                print("firstOpening : \(smokerModel.firstOpening)")
                cancellable = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
                    .sink { _ in
                        self.updateCurrentDateTime(false)
                    }
                self.updateCurrentDateTime(false)
            }
            .onChange(of: networkMonitor.isConnected) {
                if !networkMonitor.isConnected {
                    showAlert = true
                }
            }
            .onChange(of: needToReset) {
                if needToReset == true {
                    print("CA MARCHE PUTAIN DE MERDE")
                    smokerModel.daySinceFirstOpening += 1
                    smokerModel.cigaretCountThisDayMap[getOnlyDate(from: self.currentDate)] = CigaretCountThisDay(cigaretSmoked: 0, cigaretSaved: 0, gain: 0, lost: 0)
                    fillGraphData(date: getYesterdayDate(from: self.currentDate))
                    saveInSmokerDb(modelContext)
                    print("\n---------------------------------------------------------------\n")
                    print("🌿 jour depuis le debut : \(smokerModel.daySinceFirstOpening)")
                    print("🌿 date du jour : \(getOnlyDate(from: self.currentDate))")
                    print("🌿 date d'hier : \(getYesterdayDate(from: self.currentDate))")
                    print("\n---------------------------------------------------------------\n")
                    print("🔱 stats d'hier : \(String(describing: smokerModel.cigaretCountThisDayMap[getYesterdayDate(from: self.currentDate)]))")
                    print("\n")
                    print ("🔥 Stats enregistré : \(String(describing: smokerModel.graphData["Argent économisé"]?.last))")
                    print ("🔥 Stats enregistré : \(String(describing: smokerModel.graphData["Argent perdu"]?.last))")
                    print ("🔥 Stats enregistré : \(String(describing: smokerModel.graphData["Cigarettes sauvées"]?.last))")
                    print ("🔥 Stats enregistré : \(String(describing: smokerModel.graphData["Cigarettes fumées"]?.last))")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Une connexion Internet est requise"),
                    message: Text("Une connexion Internet est nécessaire pour utiliser cette application"),
                    dismissButton: .default(Text("OK"), action: {
                        if !networkMonitor.checkConnection() {
                            UIApplication.shared.quit()
                        } else {
                            showAlert = false
                            self.updateCurrentDateTime(false)
                        }
                    })
                )
            }
        }
    }
    
    private func initializeSmokerModel(){
        if smokerModels.isEmpty {
            
            let newSmokerModel = SmokerModel(
                firstOpening: false,
                cigaretInfo: CigaretInfos(kindOfCigaret: "", priceOfCigaret: 0.0, numberOfCigaretAnnounced: 0),
                cigaretCountThisDayMap: [:],
                cigaretTotalCount: CigaretTotalCount(cigaretSmoked: 0, cigaretSaved: 0, gain: 0, lost: 0),
                numberOfCigaretProgrammedThisDay: 0,
                daySinceFirstOpening: 0,
                needToReset: false,
                lastOpening: Date(),
                firstOpeningDate: nil,
                graphData: [:]
            )
            modelContext.insert(newSmokerModel)
            do {
                try modelContext.save()
            } catch {
                print("db already initialized")
            }
            print("je passe par l'init")
        }
        smokerModel = smokerModels.first
        if smokerModel == nil {
            print("smokerModel is nil")
        } else {
            print("smokerModel is not nil")
        }
    }
    
    private func updateCurrentDateTime(_ test: Bool) {
        // Si un seul param et que c'est une closure pas besoin de () apres l'appel
        print("App is back in the foreground, fetching current date and time\n\n")
        fetchCurrentDate { date in
            if let date = date {
                DispatchQueue.main.async {
                    if !test {
                        self.currentDate = date
                    }
                    if smokerModel.firstOpeningDate == nil {
                        smokerModel.firstOpeningDate = getOnlyDate(from: self.currentDate)
                        saveInSmokerDb(modelContext)
                        return
                    }
                    let calendar = Calendar.current
                    if test {
                        self.currentDate = calendar.date(byAdding: .hour, value: 26, to: self.currentDate)!
                        print("\nTest mode activated, current date and time updated: \(self.currentDate)\n")
                    }
                    self.test = date.description
                    
                    let savedDate = smokerModel.lastOpening
                    
                    let timeZone = TimeZone(secondsFromGMT: 0)
                    var calendarWithTimeZone = calendar
                    calendarWithTimeZone.timeZone = timeZone!
                    
                    let savedDateComponent = calendarWithTimeZone.dateComponents([.year, .month, .day], from: savedDate)
                    let savedCurrentDateComponent = calendarWithTimeZone.dateComponents([.year, .month, .day], from: self.currentDate)
                    
                    guard let startOfSavedDate = calendarWithTimeZone.date(from: savedDateComponent),
                          let startOfCurrentDate = calendarWithTimeZone.date(from: savedCurrentDateComponent) else {
                        print("error guard")
                        return
                    }
                    
                    let isNextDay = startOfCurrentDate >= calendarWithTimeZone.date(byAdding: .day, value: 1, to: startOfSavedDate)!
                    
                    
                    
                    let hourComponent = calendarWithTimeZone.component(.hour, from: self.currentDate)
                    let isPastFourAm = hourComponent >= 4
                    print("✅Last opening date and time: \(savedDate)")
                    print("✅Current date and time: \(self.currentDate)")
                    
                    print("\n🔥 isNextDay: \(isNextDay)")
                    print("🔥 isPastFourAm: \(isPastFourAm)")
                    print("🔥 hourComponent: \(hourComponent)")
                    
                    
                    if isNextDay && isPastFourAm {
                        self.needToReset = true
                        print("Resetting values")
                    }
                    else {
                        print("Ca reset pas")
                    }
                    smokerModel.lastOpening = currentDate
                    saveInSmokerDb(modelContext)
                    print("App is back in the foreground, current date and time updated: \(self.currentDate)")
                    print("Date in DB is --> \(smokerModel.lastOpening)")
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
    
    //let options = ["Argent économisé", "Argent perdu", "Cigarettes sauvées", "Cigarettes fumées"]
    private func fillGraphData(date: String) {
        if let cigaretData = self.smokerModel.cigaretCountThisDayMap[date] {
            let cigaretSmoked = cigaretData.cigaretSmoked
            let cigaretSaved = cigaretData.cigaretSaved
            let moneyEarned = cigaretData.gain
            let moneyLost = cigaretData.lost
            let daySinceFirstOpening = smokerModel.daySinceFirstOpening
            
            if daySinceFirstOpening == 1 {
                
                smokerModel.graphData["Argent économisé"] = [graphDataStruct(index: "0", value: 0.0)]
                smokerModel.graphData["Argent perdu"] = [graphDataStruct(index: "0", value: 0.0)]
                smokerModel.graphData["Cigarettes sauvées"] = [graphDataStruct(index: "0", value: 0.0)]
                smokerModel.graphData["Cigarettes fumées"] = [graphDataStruct(index: "0", value: 0.0)]
                saveInSmokerDb(modelContext)
            }
            
            smokerModel.graphData["Argent économisé"]?.append(graphDataStruct(index: String(daySinceFirstOpening), value: moneyEarned))
            smokerModel.graphData["Argent perdu"]?.append(graphDataStruct(index: String(daySinceFirstOpening), value: moneyLost))
            smokerModel.graphData["Cigarettes sauvées"]?.append(graphDataStruct(index: String(daySinceFirstOpening), value: Double(cigaretSaved)))
            smokerModel.graphData["Cigarettes fumées"]?.append(graphDataStruct(index: String(daySinceFirstOpening), value: Double(cigaretSmoked)))
        }
    }
    
    struct MainMenuView: View {
        
        @Binding var smokerModel: SmokerModel?
        @Binding var needToReset: Bool
        @Binding var startTest: Bool
        @Binding var addDay: Bool
        
        let updateCurrentDateTime: (Bool) -> Void
        
        var body: some View {
                MainBoardView(smokerModel: $smokerModel, needToReset: $needToReset, addDay: $addDay, startTest: $startTest)
                .onChange(of: addDay) {
                    if addDay {
                        updateCurrentDateTime(true)
                        addDay = false
                    }
                }
                
            }
        }
    }
    
    struct ToDayStatsView : View {
        @Binding var smokerModel: SmokerModel?
        @Binding var weekStats: Bool
        
        var body: some View {
            DayStatsView(smokerModel: $smokerModel, weekStats: $weekStats)
        }
    }
    
    #Preview {
        ContentView()
            .modelContainer(for: SmokerModel.self, inMemory: true)
    }
