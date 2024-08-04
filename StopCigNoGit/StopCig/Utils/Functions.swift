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

