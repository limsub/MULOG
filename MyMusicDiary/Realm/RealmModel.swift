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
        
        let dateString = Constant.DateFormat.realmDateFormatter.string(from: day)
        

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
    
    convenience init(id: String, name: String, artist: String, bigImageURL: String?, smallImageURL: String?, previewURL: String?, genres: [String]) {
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
    }

}
