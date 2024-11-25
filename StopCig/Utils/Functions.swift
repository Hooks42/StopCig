//
//  Functions.swift
//  StopCig
//
//  Created by Hook on 03/08/2024.
//

import SwiftData
import UIKit

func saveInSmokerDb(_ context: ModelContext)
{
    do
    {
        try context.save()
    }
    catch
    {
        print("Error saving context: \(error.localizedDescription)")
    }
}

func findKeyByVal<K: Hashable, V: Equatable>(dictionnary: [K : V], value: V) -> K? {
    for (key, val) in dictionnary {
        if val == value {
            return key
        }
    }
    return nil
}

func getDecimalPartAsInt(from number: Double) -> Int {
    let shiftedNumber = number * 100
    
    let decimalPart = shiftedNumber.truncatingRemainder(dividingBy: 100)
    
    return Int(decimalPart)
}

func getOnlyDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.string(from: date)
}

func getYesterdayDate(from date: Date) -> String {
    let calendar = Calendar.current
    guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else { return ""}
    return getOnlyDate(from: previousDate)
}



func truncateText(_ text: String, maxLength: Int) -> String {
    if text.count > maxLength {
        let index = text.index(text.startIndex, offsetBy: maxLength)
        return String(text[..<index] + "...")
    } else {
        return text
    }
}

func getInfosByIndexInGraphData(model: SmokerModel?, index: String, selectedOption: String, isDay: Bool) -> String
{
    let ERROR = ""
    
    let smokerModel = model
    if smokerModel == nil { return ERROR}
    
    var itemFound: [graphDataStruct]
    
    
    guard let graphDataDay = smokerModel?.graphDataDay else { return ERROR}
    guard let graphDataWeek = smokerModel?.graphDataWeek else { return ERROR}
    if isDay {
        itemFound = graphDataDay[selectedOption]?.filter{$0.index == index} ?? []
    } else {
        itemFound = graphDataWeek[selectedOption]?.filter{$0.index == index} ?? []
    }
    if !itemFound.isEmpty {
        if itemFound[0].value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(itemFound[0].value))
        }
        return String(format: "%.2f", itemFound[0].value)
    }
    
    return ERROR
}

func getGraphDataWeekInfos(smokerModel: SmokerModel?, at: Int, to: Int) -> (Double, Double, Double, Double) {
    let smokerModelVar = smokerModel
    if smokerModelVar == nil { print("⚠️ SmokerModel Error") ; return (0.0, 0.0, 0.0, 0.0)}
    
    let graphDataDay = smokerModelVar?.graphDataDay
    if graphDataDay == nil { print("⚠️ GraphDataDay Error") ; return (0.0, 0.0, 0.0, 0.0)}
    
    var weekStats : (Double, Double, Double, Double) = (0.0, 0.0, 0.0, 0.0)
    
    for i in at...to {
        let moneySavedItem = graphDataDay!["Argent économisé"]?.filter{$0.index == String(i)} ?? []
        let moneyLostItem = graphDataDay!["Argent perdu"]?.filter{$0.index == String(i)} ?? []
        let cigaretSavedItem = graphDataDay!["Cigarettes sauvées"]?.filter{$0.index == String(i)} ?? []
        let cigaretSmokedItem = graphDataDay!["Cigarettes fumées"]?.filter{$0.index == String(i)} ?? []
        
        if moneySavedItem.isEmpty || moneyLostItem.isEmpty || cigaretSavedItem.isEmpty || cigaretSmokedItem.isEmpty { print("⚠️ issue with filter") ; return (0.0, 0.0, 0.0, 0.0)}
        
        weekStats.0 += moneySavedItem[0].value
        weekStats.1 += moneyLostItem[0].value
        weekStats.2 += cigaretSavedItem[0].value
        weekStats.3 += cigaretSmokedItem[0].value
    }
    
    return weekStats
}

func fillGraphData(smokerModel: SmokerModel?, date: String, isDay: Bool, modelContext: ModelContext) {
    
    let smokerModelVar = smokerModel
    if smokerModelVar == nil { return }
    
    if let cigaretData = smokerModelVar?.cigaretCountThisDayMap[date] {
        let cigaretSmokedDay = cigaretData.cigaretSmoked
        let cigaretSavedDay = cigaretData.cigaretSaved
        let moneyEarnedDay = cigaretData.gain
        let moneyLostDay = cigaretData.lost
        let daySinceFirstOpening = smokerModelVar?.daySinceFirstOpening
        
        if daySinceFirstOpening == 1 && isDay {
            smokerModelVar?.graphDataDay["Argent économisé"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataDay["Argent perdu"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataDay["Cigarettes sauvées"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataDay["Cigarettes fumées"] = [graphDataStruct(index: "0", value: 0.0)]
            saveInSmokerDb(modelContext)
        }
        
        if daySinceFirstOpening == 7 && !isDay {
            smokerModelVar?.graphDataWeek["Argent économisé"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataWeek["Argent perdu"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataWeek["Cigarettes sauvées"] = [graphDataStruct(index: "0", value: 0.0)]
            smokerModelVar?.graphDataWeek["Cigarettes fumées"] = [graphDataStruct(index: "0", value: 0.0)]
            saveInSmokerDb(modelContext)
        }
        
        if isDay {
            print("\n\n---------------------------------------------------------------\n\n")
            print("🌿 DAYSTATS : \(cigaretSavedDay) \(cigaretSmokedDay) \(moneyEarnedDay) \(moneyLostDay)\n\n")
            smokerModelVar?.graphDataDay["Argent économisé"]?.append(graphDataStruct(index: String(daySinceFirstOpening!), value: moneyEarnedDay))
            smokerModelVar?.graphDataDay["Argent perdu"]?.append(graphDataStruct(index: String(daySinceFirstOpening!), value: moneyLostDay))
            smokerModelVar?.graphDataDay["Cigarettes sauvées"]?.append(graphDataStruct(index: String(daySinceFirstOpening!), value: Double(cigaretSavedDay)))
            smokerModelVar?.graphDataDay["Cigarettes fumées"]?.append(graphDataStruct(index: String(daySinceFirstOpening!), value: Double(cigaretSmokedDay)))
        } else {
            if daySinceFirstOpening != nil {
                let weekStats = getGraphDataWeekInfos(smokerModel: smokerModelVar, at: daySinceFirstOpening! - 6, to: daySinceFirstOpening!)
                smokerModelVar?.graphDataWeek["Argent économisé"]?.append(graphDataStruct(index: String(daySinceFirstOpening! / 7), value: weekStats.0))
                smokerModelVar?.graphDataWeek["Argent perdu"]?.append(graphDataStruct(index: String(daySinceFirstOpening! / 7), value: weekStats.1))
                smokerModelVar?.graphDataWeek["Cigarettes sauvées"]?.append(graphDataStruct(index: String(daySinceFirstOpening! / 7), value: weekStats.2))
                smokerModelVar?.graphDataWeek["Cigarettes fumées"]?.append(graphDataStruct(index: String(daySinceFirstOpening! / 7), value: weekStats.3))
                print("\n\n---------------------------------------------------------------\n\n")
                print("🌿 WEEKSTATS : \(weekStats)\n\n")
                print("\n\n---------------------------------------------------------------\n\n")
            }
        }
    }
    saveInSmokerDb(modelContext)
}



extension UIApplication {
    func quit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

