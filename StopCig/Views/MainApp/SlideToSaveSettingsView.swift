//
//  SlideToSaveSettingsView.swift
//  StopCig
//
//  Created by Hook on 27/11/2024.
//

import SwiftUI


struct SlideToSaveSettingsView: View {
    
    @Binding var smokerModel: SmokerModel?
    @Binding var isSheetPresented: Bool
    @Binding var newPrice: Double
    @Binding var newObjective: Int
    
    @State private var unlocked = false
    @State private var offset : CGFloat = 0
    @State private var maxWidth : CGFloat = 0
    @State private var startOffset : CGFloat = 0
    
    @Environment(\.modelContext) private var modelContext
    

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.07)
                    .overlay(
                        Text("Sauvegarder")
                            .foregroundColor(.white.opacity(0.7))
                    )
                HStack {
                    if self.unlocked {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(Color.myYellow)
                            .clipShape(Circle())
                            .offset(x: self.offset)
                        Spacer()
                    } else {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(Color.myYellow)
                            .clipShape(Circle())
                            .offset(x: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        self.maxWidth = (geo.size.width * 0.9) - (geo.size.width * 0.07)
                                        if gesture.translation.width > self.startOffset && gesture.translation.width <= self.maxWidth {
                                            self.offset = gesture.translation.width
                                        }
                                    }
                                    .onEnded { _ in
                                        if self.offset >= self.maxWidth - 20 {
                                            withAnimation {
                                                self.offset = self.maxWidth
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    self.unlocked = true
                                                }
                                            }
                                        } else {
                                            withAnimation {
                                                self.offset = self.startOffset
                                            }
                                        }
                                    }
                            )
                        Spacer()
                    }
                }
            }
            .onChange(of: unlocked) {
                if unlocked {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        smokerModel?.cigaretInfo.priceOfCigaret = self.newPrice
                        smokerModel?.numberOfCigaretProgrammedThisDay = self.newObjective
                        saveInSmokerDb(modelContext)
                        print("now price of cigaret is \(smokerModel?.cigaretInfo.priceOfCigaret ?? 0)")
                        print("now number of cigarets per day is \(smokerModel?.numberOfCigaretProgrammedThisDay ?? 0)")
                        self.isSheetPresented = false
                        
                    }
                }
            }
            .onAppear() {
                self.startOffset = geo.size.width * 0.058
                self.offset = self.startOffset
                
            }
        }

    }
}

#Preview {
    ZStack {
        Color(.nightBlue)
            .edgesIgnoringSafeArea(.all)
        SlideToSaveSettingsView(smokerModel: .constant(nil), isSheetPresented: .constant(true), newPrice: .constant(0.0), newObjective: .constant(0))

    }
}
