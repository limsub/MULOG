//
//  MusicItemTableRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/28.
//

import Foundation
import RealmSwift

class MusicItemTableRepository {
    
    let realm = try! Realm()
    
    
    func createDayItem(_ item: DayItemTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Create Error : ", error)
            // Alert : 데이터를 저장하는 과정에서 문제가 생겼습니다
        }
    }
    
    func appendMusicItem(_ dayItem: DayItemTable, musicItem: MusicItemTable) {
        do {
            try realm.write {
                dayItem.musicItems.append(musicItem)
            }
        } catch {
            
        }
    }
    
    
    
    func createMusicItem(_ item: MusicItemTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Create Error : ", error)
            // Alert : 데이터를 저장하는 과정에서 문제가 생겼습니다
        }
    }
    
    func fetchMusic() -> Results<MusicItemTable> {
        let data = realm.objects(MusicItemTable.self)
        return data
    }
    func fetchMusic(_ id: String) -> MusicItemTable? {
        let data = realm.objects(MusicItemTable.self).where {
            $0.id == id
        }
        return data.first
    }
    func fetchDay() -> Results<DayItemTable> {
        let data = realm.objects(DayItemTable.self)
        return data
    }
    func fetchDay(_ day: Date) -> DayItemTable? {
        let dateString = Constant.DateFormat.realmDateFormatter.string(from: day)
        
        let data = realm.objects(DayItemTable.self).where {
            $0.day == dateString
        }
        return data.first
    }
    
    
    func fetchMonth(_ yearAndMonth: String) -> [DayItemTable]? {    // 202309
        
        
        let data = realm.objects(DayItemTable.self).where {
            $0.day.contains(yearAndMonth)
        }
        
        var ans: [DayItemTable] = []
        
        data.forEach { item in
            ans.append(item)
        }
        
        return ans
    }
    
    func alreadySave(_ id: String) -> MusicItemTable? {
        let data = realm.objects(MusicItemTable.self).where {
            $0.id == id
        }
        
        return data.first
    }
    
    
    func plusCnt(_ data: MusicItemTable) {
        do {
            try realm.write {
                realm.create(
                    MusicItemTable.self,
                    value: ["id": data.id, "name": data.name,
                            "artist": data.artist, "bigImageURL": data.bigImageURL, "smallImageURL": data.smallImageURL, "previewURL": data.previewURL, "genres": data.genres, "count": data.count + 1],
                    update: .modified
                )
            }
        } catch {
            print("업데이트 에러")
        }
    }
    
    func makeMusicItemTable(_ data: MusicItem) -> MusicItemTable {

        let colorArr: [Float]
        if let CGColorArr = data.backgroundColor?.components {
            colorArr = CGColorArr.map{ Float($0) }
        } else {
            colorArr = [0.0, 0.0, 0.0, 0.0]
        }
        
        return MusicItemTable(id: data.id, name: data.name, artist: data.artist, bigImageURL: data.bigImageURL, smallImageURL: data.smallImageURL, previewURL: data.previewURL?.absoluteString, genres: data.genres, colors: colorArr)
    }
    
    
    
}
