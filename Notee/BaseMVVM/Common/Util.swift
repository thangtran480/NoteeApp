//
//  Util.swift
//  Notee
//
//  Created by ThangTV28 on 20/07/2021.
//

import Foundation
class Util{
    static func reomveTimeFrom(_ date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date = Calendar.current.date(from: components)
        return date!
    }
    static func cvtDateToString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.string(from: date)
    }
    static func cvtDateTimeToString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd    HH:mm"
        
        return dateFormatter.string(from: date)
    }
}
