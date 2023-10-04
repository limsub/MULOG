//
//  Constant.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit


enum Constant {
    
    static let headerDateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en")
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
    enum Color {
        static let main = UIColor(hexCode: "#C8A2C8")
    }
    
}
