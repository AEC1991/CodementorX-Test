//
//  DateExtension.swift
//
//  Created by Star on 2/24/19.
//  Copyright © 2019 Boris. All rights reserved.
//

import Foundation
import UIKit


extension Date {
    
    func stringAMPM() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: self)
    }
    
    func stringFormat(_ format : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func stringMMddyyyy() -> String {
        return stringFormat("MMddyyyy")
    }
    
    func stringMM_dd_yyyy() -> String {
        return stringFormat("MM/dd/yyyy")
    }

    func stringMM_YYYY() -> String {
        return stringFormat("MM/yyyy")
    }

    func stringWeeklyDay() -> String {
        return stringFormat("EEEE dd MMMM yyyy")
    }
    
    func stringMMddyyyyHHmmss() -> String {
        return stringFormat("MM dd yyyy HH:mm:ss")
    }
    
    func stringDayOfWeek() -> String {
        return stringFormat("EEEE")
    }
    

    func isValidBetween(start: Date, end:Date) -> Bool {
        var result = false
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        guard let day = calendar.ordinality(of: .day, in: .year, for: self) else {return result}
        
        
        let yearStart = calendar.component(.year, from: start)
        guard let dayStart = calendar.ordinality(of: .day, in: .year, for: start) else {return result}
        
        let yearEnd = calendar.component(.year, from: end)
        guard let dayEnd = calendar.ordinality(of: .day, in: .year, for: end) else {return result}
        
        
        if year >= yearStart,
            year <= yearEnd {
            if year == yearStart {
                if day >= dayStart {
                    result = true
                }else {
                    result = false
                }
            }
            if result == true, year == yearEnd {
                if day <= dayEnd {
                    result = true
                }else {
                    result = false
                }
            }
            if year > yearStart,
                year < yearEnd{
                result = true
            }
        }else {
            result = false
        }
        return result
    }
    
    func dateWithAMPM (ampm : Date) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM dd"
        var stringTime = formatter.string(from: self)
        let ampmTime = ampm.stringAMPM()
        stringTime = stringTime + " " + ampmTime
        formatter.dateFormat = "yyyy MMMM dd h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter.date(from: stringTime)
    }
    
    func dateWithAMPM (ampm : String, isSecond : Bool = false) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM dd"
        var stringTime = formatter.string(from: self)
        stringTime = stringTime + " " + ampm
        if isSecond == false {
            formatter.dateFormat = "yyyy MMMM dd h:mm a"
        }else {
            formatter.dateFormat = "yyyy MMMM dd h:mm:ss a"
        }
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter.date(from: stringTime)
    }
    
    
    func isIn10minuWith (date : Date) -> Bool {
        
        var result = false
        let deltaMinu = (date.timeIntervalSince1970 - self.timeIntervalSince1970) / 60
        if deltaMinu >= 0,
            deltaMinu <= 10 {
            result = true
        }
        
        return result
    }
    
    func stringGreeting() -> String {
        var result = "Good Morning"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        if hour >= 0, hour < 12 {
            result = "Good Morning"
        }else if hour >= 12, hour < 18 {
            result = "Good Afternoon"
        }else if hour >= 18, hour < 24 {
            result = "Good Evening"
        }
        return result
    }
    
    func stringMorning() -> String {
        var result = "morning"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        if hour >= 0, hour < 12 {
            result = "morning"
        }else if hour >= 12, hour < 18 {
            result = "afternoon"
        }else if hour >= 18, hour < 24 {
            result = "evening"
        }
        return result
    }
    
    
    func stringMeal() -> String {
        var result = "breakfast"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        if hour >= 0, hour < 12 {
            result = "breakfast"
        }else if hour >= 12, hour < 18 {
            result = "lunch"
        }else if hour >= 18, hour < 24 {
            result = "dinner"
        }
        return result
    }
    
    func isMissedTimeForMeal () -> Bool {
        var result = false
        
        let am11 = self.dateWithAMPM(ampm: "11:00 AM")
        let pm12 = self.dateWithAMPM(ampm: "12:00 PM")
        let pm3 = self.dateWithAMPM(ampm: "3:00 PM")
        let pm6 = self.dateWithAMPM(ampm: "6:00 PM")
        let pm10 = self.dateWithAMPM(ampm: "10:00 PM")
        let am12 = self.dateWithAMPM(ampm: "11:59 PM")
        
        if (self > am11! && self <= pm12!) ||
            (self > pm3! && self <= pm6!) ||
            (self > pm10! && self <= am12!) {
            result = true
        }
        
        return result
    }
    
    func hoursDecimal() -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let min = calendar.component(.minute, from: self)
        let result = CGFloat(hour) + CGFloat(min) / 60
        
        return result
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
}
