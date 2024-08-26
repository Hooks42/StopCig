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
