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

struct CigaretDayCount : Codable {
    var thisDay: Int
    var thisWeek: Int
    var thisMonth: Int
}

@Model
final class SmokerModel {
    var firstOpening : Bool
    var cigaretInfo : CigaretInfos
    var numberOfCigaretProgrammedThisDay: Int
    var cigaretSmoked : CigaretDayCount
    var gain: Double
    var needToReset: Bool
    
    init(firstOpening: Bool, cigaretInfo: CigaretInfos, numberOfCigaretProgrammedThisDay: Int, cigaretSmoked: CigaretDayCount,
        gain: Double, needToReset: Bool) {
        self.firstOpening = firstOpening
        self.cigaretInfo = cigaretInfo
        self.numberOfCigaretProgrammedThisDay = numberOfCigaretProgrammedThisDay
        self.cigaretSmoked = cigaretSmoked
        self.gain = gain
        self.needToReset = needToReset
    }
}
