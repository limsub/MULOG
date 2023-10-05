//
//  Extension+String.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/05.
//

import Foundation


extension String {
    
    func toDate(to type: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: self)
    }
}
