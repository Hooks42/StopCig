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



extension UIApplication {
    func quit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

