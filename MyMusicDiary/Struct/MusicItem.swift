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
    
  
    
    init(_id: UUID = UUID(), id: String, name: String, artist: String, bigImageURL: String? = nil, smallImageURL: String? = nil, previewURL: String? = nil, genres: [String], backgroundColor: CGColor? = CGColor(red: 0, green: 0, blue: 0, alpha: 0)) {
        self._id = _id
        self.id = id
        self.name = name
        self.artist = artist
        self.bigImageURL = bigImageURL
        self.smallImageURL = smallImageURL
        self.previewURL = previewURL
        self.genres = genres
        self.backgroundColor = backgroundColor
    }

    
    init(_ musicItemTable: MusicItemTable) {
        self.id = musicItemTable.id
        self.name = musicItemTable.name
        self.artist = musicItemTable.artist
        self.bigImageURL = musicItemTable.bigImageURL
        self.smallImageURL = musicItemTable.smallImageURL
        self.previewURL = musicItemTable.previewURL

        self.genres = Array(musicItemTable.genres)

        self.backgroundColor = CGColor(
            red: CGFloat(musicItemTable.backgroundColors[0]),
            green: CGFloat(musicItemTable.backgroundColors[1]),
            blue: CGFloat(musicItemTable.backgroundColors[2]),
            alpha: CGFloat(musicItemTable.backgroundColors[3])
        )

    }
}
