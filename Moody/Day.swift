//
//  Day.swift
//  CalSwiftUI
//
//  Created by Adam Kes on 11/12/19.
//  Copyright © 2019 KesDev. All rights reserved.
//

import Foundation
import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)



class Day: ObservableObject {
    
    @ObservedObject var mp = FetchUserModel()
    
    @Published var isSelected = false
    @Published var hasMood = false
    @Published var mood: String = ""
    @State var shouldShowPrompt = false
    
    var selectableDays: Bool
    var dayDate: Date
    var dayName: String {
        dayDate.dateToString(format: "d")
    }
    var dayComplete: String {
        dayDate.dateToString(format: "dd MMM yyyy")
    }
    var isToday = false
    var disabled = false
    
    let colors = Colors()
    var textColor: Color {
        if isSelected {
            return colors.selectedColor
        } else if isToday {
            return colors.todayColor
        } else if disabled {
            return colors.disabledColor
        }
        return colors.textColor
    }
    var backgroundColor: Color {
//        print(dayComplete,mood,isSelected,hasMood)
//        print(mp.user?.moodDays[dayComplete] ?? "what?")
//        print(mp.user?.moodDays ?? "what?")
//        if mp.user?.moodDays[dayComplete] != nil{
//            return getMoodColor()
//        }
//        else
        if isSelected {
            if hasMood{
                return getMoodColor()
            } else {
                return colors.selectedBackgroundColor
            }
            
        } else {
            return colors.backgroundColor
        }
    }
    
    init(date: Date, today: Bool = false, disable: Bool = false, selectable: Bool = true, isSelected: Bool = false, hasMood: Bool = false, mood: String = "") {
        dayDate = date
        isToday = today
        disabled = disable
        selectableDays = selectable
        self.isSelected = isSelected
        self.hasMood = hasMood
        self.mood = mood
    }
    
    private func getMoodColor() -> Color {
        if mood == "good" {
            return colors.goodBackgroundColor
        } else if mood == "meh" {
            return colors.mehBackgroundColor
        } else if mood == "bad"{
            return colors.badBackgroundColor
        } else {
            return colors.weekdayBackgroundColor
        }
    }
    
}
