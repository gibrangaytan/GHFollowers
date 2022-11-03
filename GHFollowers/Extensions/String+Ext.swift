//
//  String+Ext.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/2/22.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.timeZone = .current
        
        return dateFormater.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "Uable to parse date" }
        return date.convertToMonthYearFormat()
    }
}
