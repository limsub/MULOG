//
//  Enum+DateFormatType.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/05.
//

import Foundation

// TODO: Localization
enum DateFormatType: String {
    case singleMonth = "M"
    case month = "MM"
    case fullMonth = "MMMM"
    
    case slashMonthDay = "M/dd"
    
    case year = "yyyy"
    
    case fullMonthYear = "MMMM yyyy"
    
    case yearMonth = "yyyyMM"
    
    case full = "yyyyMMdd"
    
    case fullSlashWithSingelMonth = "yyyy/M/dd"
    
    case fullSlashWithSingleMonthAndYoil = "yyyy/M/dd (EEE)"
    
    case fullKorean = "yyyy년 M월 dd일"
    case monthYearKorean = "M월 dd일"
    
    
    case hour = "HH"
    case minute = "mm"
    case hourMinute = "HHmm"
    
    
    case yoil = "EEE"
    
    case day = "dd"
    
    case singleDay = "d"
    
    case instaStory = "MMMM d, yyyy"
    
    
    static func calculateDayCnt(_ starDayString: String) -> Int {
    
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: starDayString.toDate(to: .full) ?? Date())
        if let nextMonthDate = calendar.date(from: components),
           let lastDay = calendar.date(byAdding: DateComponents(day: -1), to: calendar.date(byAdding: DateComponents(month: 1), to: nextMonthDate)!) {

            return calendar.component(.day, from: lastDay)
        } else {
            return 30
        }
    }
    
    // 주의 첫날과 마지막 날 리턴
    static func getStartAndEndDateOfWeek(for date: Date) -> (Date, Date)? {
        let calendar = Calendar.current
        
        // 주의 시작 날짜 찾기
        var startDate = Date()
        var interval = TimeInterval(0)
        _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: date)
        
        // 주의 마지막 날짜 찾기
        let endDate = calendar.date(byAdding: .day, value: +6, to: startDate)!
        
        return (startDate, endDate)
    }

}
