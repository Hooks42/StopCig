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

struct CigaretCountThisDay : Codable {
    var cigaretSmoked : Int
    var cigaretSaved : Int
    var gain : Double
    var lost : Double
}

struct CigaretTotalCount : Codable {
    var cigaretSmoked : Int
    var cigaretSaved : Int
    var gain : Double
    var lost : Double
}


@Model
final class SmokerModel {
    var firstOpening : Bool
    var cigaretInfo : CigaretInfos
    var cigaretCountThisDayMap : [Date:CigaretCountThisDay]
    var cigaretTotalCount : CigaretTotalCount
    var numberOfCigaretProgrammedThisDay: Int
    var daySinceFirstOpening: Int
    var needToReset: Bool
    var lastOpening: Date
    var firstOpeningDate: Date
    
    init(firstOpening: Bool, cigaretInfo: CigaretInfos, cigaretCountThisDayMap: [Date:CigaretCountThisDay],
         cigaretTotalCount: CigaretTotalCount, numberOfCigaretProgrammedThisDay: Int,
         daySinceFirstOpening: Int, needToReset: Bool, lastOpening: Date, firstOpeningDate: Date) {
        self.firstOpening = firstOpening
        self.cigaretInfo = cigaretInfo
        self.cigaretCountThisDayMap = cigaretCountThisDayMap
        self.cigaretTotalCount = cigaretTotalCount
        self.numberOfCigaretProgrammedThisDay = numberOfCigaretProgrammedThisDay
        self.daySinceFirstOpening = daySinceFirstOpening
        self.needToReset = needToReset
        self.lastOpening = lastOpening
        self.firstOpeningDate = firstOpeningDate
    }
}
