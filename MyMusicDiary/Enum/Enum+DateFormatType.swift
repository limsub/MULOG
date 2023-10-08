//
//  Enum+DateFormatType.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/05.
//

import Foundation


enum DateFormatType: String {
    case singleMonth = "M"
    case month = "MM"
    case fullMonth = "MMMM"
    
    case year = "yyyy"
    
    case fullMonthYear = "MMMM yyyy"
    
    case yearMonth = "yyyyMM"
    
    case full = "yyyyMMdd"
    
    case fullSlashWithSingelMonth = "yyyy/M/dd"
    
}
