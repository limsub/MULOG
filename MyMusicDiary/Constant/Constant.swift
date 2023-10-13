//
//  Constant.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit


enum Constant {
    
    enum DateFormat {
        static let headerDateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "en")
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter
        }()
        
        static let realmDateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter
        }()
       
    }
    
    
    
    enum Color {
        static let background = UIColor(hexCode: "#F6F6F6")
        
        static let main = UIColor(hexCode: "#C8A2C8")
        
        static let main1 = UIColor(hexCode: "#FCFCFC")
        static let main2 = UIColor(hexCode: "#73c1b2")
        static let main3 = UIColor(hexCode: "#9bcea4")
        static let main4 = UIColor(hexCode: "#c3db97")
        static let main5 = UIColor(hexCode: "#ebe88a")
    }
    
}
