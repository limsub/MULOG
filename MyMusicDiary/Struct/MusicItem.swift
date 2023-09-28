//
//  MusicItem.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation
import MusicKit


struct MusicItem: Identifiable, Hashable, Decodable {
    var _id = UUID()
    
    let id: String
    let name: String
    let artist: String
//    let imageURL: Artwork?
    let bigImageURL: String?    // 700 x 700
    let smallImageURL: String?  // 150 x 150
    let previewURL: URL?
    
    let genres: [String]
}
