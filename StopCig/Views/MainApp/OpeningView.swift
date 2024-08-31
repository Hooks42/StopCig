//
//  OpeningView.swift
//  StopCig
//
//  Created by Hook on 30/08/2024.
//

import SwiftUI

struct OpeningView: View {
    var body: some View {
        ZStack {
            PlayerView(videoName: "Smoke")
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    OpeningView()
}
