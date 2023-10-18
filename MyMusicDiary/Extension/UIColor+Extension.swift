//
//  UIColor.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit

extension UIColor {
    
    // 차트에 표시될 색상들
    enum GenreColor: String, CaseIterable {
         
         case b =   "#7baa9b"
         case a =   "#68b4a6"
         case c =   "#8acab0"
         case d =   "#9fcea4"
         case e =   "#a6d0a1"
         case f =   "#b0d7a0"
         case g =   "#c2dca5"
         case h =   "#c7dab0"
         case i =   "#dde79a"
         case j =   "#f1efa3"
         case k =   "#f7f6a6"
         case l =   "#f8f8ad"
         case m =   "#f9f9b4"
         case n =   "#fafab9"
         case o =   "#fbfbbf"
    }

    // hexCode로 UIColor 반환
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
