//
//  RealmModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/28.
//

import Foundation
import RealmSwift


class DayItemTable: Object {
    
    @Persisted(primaryKey: true) var day: String    // 20230928
    @Persisted var musicItems: List<MusicItemTable>
    
    convenience init(day: Date) {
        self.init()
        
        let dateString = day.toString(of: .full)
        self.day = dateString
    }
}

class MusicItemTable: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var artist: String
    @Persisted var bigImageURL: String?
    @Persisted var smallImageURL: String?
    @Persisted var previewURL: String?
    
    @Persisted var genres: List<String> = List<String>()
    
    @Persisted var count: Int = 1
    
    @Persisted var backgroundColors: List<Float> = List<Float>()
    
    @Persisted var dateList: List<String> = List<String>()  // [20221011, 20221123, 20221201, ...]
    
    
    @Persisted var appleMusicURL: String?
    
    convenience init(id: String, name: String, artist: String, bigImageURL: String?, smallImageURL: String?, previewURL: String?, genres: [String], colors: [Float], appleMusicURL: String?) {
        self.init()
        
        self.id = id
        self.name = name
        self.artist = artist
        self.bigImageURL = bigImageURL
        self.smallImageURL = smallImageURL
        self.previewURL = previewURL
        
        genres.forEach { item in
            self.genres.append(item)
        }
        colors.forEach { item in
            self.backgroundColors.append(item)
        }
        
        self.appleMusicURL = appleMusicURL
    }
    
    convenience init(musicItem: MusicItem) {
        self.init()
        
        let colorArr: [Float]
        if let CGColorArr = musicItem.backgroundColor?.components {
            colorArr = CGColorArr.map{ Float($0) }
        } else {
            colorArr = [0.0, 0.0, 0.0, 0.0]
        }
        
        self.id = musicItem.id
        self.name = musicItem.name
        self.artist = musicItem.artist
        self.bigImageURL = musicItem.bigImageURL
        self.smallImageURL = musicItem.smallImageURL
        self.previewURL = musicItem.previewURL
        
        musicItem.genres.forEach { item in
            self.genres.append(item)
        }
        colorArr.forEach { item in
            self.backgroundColors.append(item)
        }
        
        self.appleMusicURL = musicItem.appleMusicURL
    }

}
