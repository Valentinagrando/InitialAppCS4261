//
//  MonthView.swift
//  CalSwiftUI
//
//  Created by Adam Kes on 11/12/19.
//  Copyright © 2019 KesDev. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)

struct MonthView: View {
    
    @ObservedObject private var mp = FetchUserModel()
    var month: Month
    var body: some View {
        
        VStack {
            Text("\(month.monthNameYear)")
            GridStack(rows: month.monthRows, columns: month.monthDays.count) { row, col in
                if self.month.monthDays[col+1]![row].dayDate == Date(timeIntervalSince1970: 0) {
                    Text("").frame(width: 32, height: 32)
                } else {
                    DayCellView(day: checkIfExists(dayiq: self.month.monthDays[col+1]![row]))
                }
            }
            
        }
        .padding(.bottom, 20)
    }
}

private func checkIfExists(dayiq: Day) -> Day{
    @ObservedObject var mp = FetchUserModel()
    if ((mp.user?.moodDays[dayiq.dayComplete]) != nil){
        dayiq.isSelected = true
        dayiq.hasMood = true
        dayiq.mood = mp.user?.moodDays[dayiq.dayComplete] ?? ""
    }
    print(dayiq.isSelected,dayiq.hasMood,dayiq.mood)
    return dayiq
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(month: Month(startDate: Date(), selectableDays: true))
    }
}
