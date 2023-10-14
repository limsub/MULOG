//
//  UIColor.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit

extension UIColor {
    
    enum GenreColor: String, CaseIterable {
        
         case a =   "#68b4a6"
         case b =   "#7baa9b"
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
        
        
//         case p =   "#dcdab1"
//         case q =   "#e1d9ad"
//         case r =   "#e7d9a9"
//         case s =   "#ecd9a5"
//         case t =   "#f1d8a2"
        
////       case whiteSmoke =  "#F5F5F5"
//       case gainsboro =  "#E0E0E0"
//       case lightGray =  "#D3D3D3"
//       case silver =  "#C0C0C0"
//       case gray =  "#B0B0B0"
//       case darkGray =  "#A9A9A9"
//       case gray2 =  "#808080"
//       case dimGray =  "#696969"
//       case lightSlateGray =  "#778899"
//       case slateGray =  "#708090"
////       case aliceBlue =  "#F0F8FF"
////       case azure =  "#F0FFFF"
//       case lavender =  "#E6E6FA"
//       case lightBlue =  "#ADD8E6"
//       case lightSteelBlue =  "#B0C4DE"
//       case skyBlue =  "#87CEEB"
//       case lightSkyBlue =  "#87CEFA"
//       case deepSkyBlue =  "#00BFFF"
//       case dodgerBlue =  "#1E90FF"
//       case cornflowerBlue =  "#6495ED"
//       case steelBlue =  "#4682B4"
//       case lightSlateGray2 =  "#5F9EA0"
//       case lightSeaGreen =  "#20B2AA"
//       case mediumAquamarine =  "#7FFFD4"
//       case aquamarine =  "#40E0D0"
//       case turquoise =  "#00CED1"
//       case mediumTurquoise =  "#48D1CC"
//       case cyan =  "#00FFFF"
//
////       case red = "#FF0000"
////       case orangeRed = "#FF4500"
////       case tomato = "#FF6347"
////       case coral = "#FF7F50"
////       case crimson = "#DC143C"
////       case hotPink = "#FF69B4"
////       case deepPink = "#FF1493"
////       case paleVioletRed = "#DB7093"
////       case fireBrick = "#B22222"
////       case darkRed = "#8B0000"
    }

    
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
