//
//  Moods.swift
//  Moody
//
//  Created by Valentina Grando on 1/30/22.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable {
    case good
    case meh
    case bad
}

enum MoodColor: String, Codable {
    case mehColor = "mehColor"
    case badColor = "badColor"
    case goodColor = "goodColor"
}

struct Emotion: Codable {
    var state: EmotionState
    var color: MoodColor
    
    var moodColor: Color {
        switch color {
        case .mehColor:
            return .orange
        case .badColor:
            return .red
        case .goodColor:
            return .green
        }
    }
}

struct Moods: Codable, Equatable, Identifiable {
    var id = UUID()
    let emotion: Emotion
    var comment: String?
    let date: Date
    
    init(emotion: Emotion, comment: String?, date: Date) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
    }
    
    static func == (lhs: Moods, rhs: Moods) -> Bool {
        if lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
    var dateString: String {
        dateFormatter.string(from: date)
    }
    
    var monthString: String {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "LLL"
        
        let month = dateFormatter1.string(from: date)
        
        return month
        
    }
    
    var dayAsInt: Int {
        let day = Calendar.current.component(.day, from: date)
        return day
    }
    
    var year: String {
        return Calendar.current.component(.year, from: date).description
    }
    
    
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()


