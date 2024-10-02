//
//  DotView.swift
//  StopCig
//
//  Created by Hook on 02/10/2024.
//

import SwiftUI

struct DotView: View {
    
    @Binding var indexTabView: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.myYellow))
                .frame(width: 100, height:20)
            switch self.indexTabView {
            case 0:
                Circle()
                    .fill(Color(.black))
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 60)
                    .onTapGesture {
                        self.indexTabView = 0
                    }
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .onTapGesture {
                        self.indexTabView = 1
                    }
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.leading, 60)
                    .onTapGesture {
                        self.indexTabView = 2
                    }
            case 1:
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 60)
                    .onTapGesture {
                        self.indexTabView = 0
                    }
                Circle()
                    .fill(Color(.black))
                    .frame(width: 10, height: 10)
                    .onTapGesture {
                        self.indexTabView = 1
                    }
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.leading, 60)
                    .onTapGesture {
                        self.indexTabView = 2
                    }
            case 2:
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 60)
                    .onTapGesture {
                        self.indexTabView = 0
                    }
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .onTapGesture {
                        self.indexTabView = 1
                    }
                Circle()
                    .fill(Color(.black))
                    .frame(width: 10, height: 10)
                    .padding(.leading, 60)
                    .onTapGesture {
                        self.indexTabView = 2
                    }
                
            default:
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 60)
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color(.white))
                    .frame(width: 10, height: 10)
                    .padding(.leading, 60)
            }
        }
    }
}

#Preview {
    DotView(indexTabView: .constant(0))
}
