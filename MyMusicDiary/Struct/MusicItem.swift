//
//  MusicItem.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation
import MusicKit
import UIKit


struct MusicItem: Identifiable, Hashable {
    var _id = UUID()
    
    let id: String
    let name: String
    let artist: String
//    let imageURL: Artwork?
    let bigImageURL: String?    // 700 x 700
    let smallImageURL: String?  // 150 x 150
    let previewURL: String?
    
    let genres: [String]
    
    var backgroundColor: CGColor? = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
}
