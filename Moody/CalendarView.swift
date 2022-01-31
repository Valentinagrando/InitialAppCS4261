//
//  CalendarView.swift
//  CalSwiftUI
//
//  Created by Adam Kes on 11/13/19.
//  Copyright © 2019 KesDev. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)
public struct CalendarView: View {
    
    let startDate: Date
    let monthsToDisplay: Int
    var selectableDays = true
    
    
    public init(start: Date, monthsToShow: Int, daysSelectable: Bool = true) {
        self.startDate = start
        self.monthsToDisplay = monthsToShow
        self.selectableDays = daysSelectable
        
    }
    
    public var body: some View {
        VStack {
            WeekdaysView()
            ScrollView {
                MonthView(month: Month(startDate: startDate, selectableDays: selectableDays))
                
                //                MoodPromptView(day: Day(date: Date()))
            }
        }
        
    }
    
    func nextMonth(currentMonth: Date, add: Int) -> Date {
        var components = DateComponents()
        components.month = add
        let next = Calendar.current.date(byAdding: components, to: currentMonth)!
        return next
    }
    
    
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(start: Date(), monthsToShow: 2)
    }
}
