//
//  SlideToAcceptView.swift
//  StopCig
//
//  Created by Hook on 19/11/2024.
//

import SwiftUI

struct SlideToAcceptView: View {
    
    @Binding    var isSheetPresented : Bool
    @Binding    var showWeekFeelingsView: Bool
    @Binding    var newCigaretsPerDay : Int
    @Binding    var smokerModel : SmokerModel?
    
    @State      var maxWidth : CGFloat = 0
    @State      var unlocked = false
    @State      var offset : CGFloat = 0
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.07)
                    .overlay(
                        Text("J'accepte les objectifs")
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
                                        if gesture.translation.width > 0 && gesture.translation.width <= self.maxWidth {
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
                                                self.offset = 0
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
                        self.isSheetPresented = false
                        self.showWeekFeelingsView = false
                        self.smokerModel?.numberOfCigaretProgrammedThisDay = self.newCigaretsPerDay
                        saveInSmokerDb(modelContext)
                    }
                }
            }
            .onAppear() {
                self.offset = geo.size.width * 0.055
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.nightBlue)
            .edgesIgnoringSafeArea(.all)
        SlideToAcceptView(isSheetPresented: .constant(true), showWeekFeelingsView: .constant(true), newCigaretsPerDay: .constant(0), smokerModel: .constant(nil))
            .offset(y: 500)
    }
}
