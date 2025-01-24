//
//  Extension+Date.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/05.
//

import Foundation

extension Date {
    func toString(of type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
    
    func toStringKorean(of type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: String(localized: "ko"))
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
        
    
    // MARK: - for localized
    func toMonthDayStringLocalized() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = String(localized: "M월 d일")
        return dateFormatter.string(from: self)
    }
    
    func toYearMonthStringLocalized() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = String(localized: "yyyy년 M월")
        return dateFormatter.string(from: self)
    }
    
    func toFullString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = String(localized: "yyyy년 M월 d일")
        return dateFormatter.string(from: self)
    }
}


extension Date {
    var convertedDate: Date {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)

        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        dateFormatter.dateFormat = dateFormat
        let sourceDate = dateFormatter.date(from: formattedDate)

        return sourceDate!
    }
}
