//
//  Smoker_Model.swift
//  StopCig
//
//  Created by Hook on 27/07/2024.
//

import Foundation
import SwiftData

struct CigaretInfos : Codable {
    var kindOfCigaret: String
    var priceOfCigaret: Double
    var numberOfCigaretAnnounced: Int
}

struct CigaretCount : Codable {
    var thisDay: Int
    var thisWeek: Int
    var thisMonth: Int
}

@Model
final class SmokerModel {
    var firstOpening : Bool
    var cigaretInfo : CigaretInfos
    var numberOfCigaretProgrammedThisDay: Int
    var cigaretSmoked : CigaretCount
    var cigaretSaved : CigaretCount
    var gain: Double
    
    init(firstOpening: Bool, cigaretInfo: CigaretInfos, numberOfCigaretProgrammedThisDay: Int, cigaretSmoked: CigaretCount, cigaretSaved: CigaretCount, gain: Double) {
        self.firstOpening = firstOpening
        self.cigaretInfo = cigaretInfo
        self.numberOfCigaretProgrammedThisDay = numberOfCigaretProgrammedThisDay
        self.cigaretSmoked = cigaretSmoked
        self.cigaretSaved = cigaretSaved
        self.gain = gain
    }
}
