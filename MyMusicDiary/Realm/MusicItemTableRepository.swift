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
    
    
    // (수정 - 저장 버튼 클릭 시) 기존에 있던 DayItemTable (오늘 날짜) 지워준다
    func deleteItem(_ item: DayItemTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
 
    
    // (저장 버튼 클릭 시). DayItemTable 인스턴스에 musicItem들을 다 추가하고, 최종적인 DayItemTable 램에 추가
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
    
    // (저장 버튼 클릭 시) DayItemTable 인스턴스에 musicItem을 추가하는 과정. 이미 램에 있는 musicItem일 수도 있고, 새로 만든 musicItem일 수도 있다
    func appendMusicItem(_ dayItem: DayItemTable, musicItem: MusicItemTable) {
        do {
            try realm.write {
                dayItem.musicItems.append(musicItem)
            }
        } catch {
            
        }
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
        
        
        let data = realm.objects(DayItemTable.self).sorted(byKeyPath: "day").where {
            $0.day.contains(yearAndMonth)
        }
        
        print(data)
        
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
    
    
    // 기존에 있었던 MusicItemTable인 경우, count를 1 올려준다
    func plusCnt(_ data: MusicItemTable) {
        do {
            try realm.write {
                realm.create(
                    MusicItemTable.self,
                    value: ["id": data.id, "name": data.name,
                            "artist": data.artist, "bigImageURL": data.bigImageURL, "smallImageURL": data.smallImageURL, "previewURL": data.previewURL, "genres": data.genres, "count": data.count + 1, "backgroundColors": data.backgroundColors, "dateList": data.dateList],
                    update: .modified
                )
            }
        } catch {
            print("업데이트 에러")
        }
    }
    
    func minusCnt(_ data: MusicItemTable) {
        do {
            try realm.write {
                realm.create(
                    MusicItemTable.self,
                    value: ["id": data.id, "name": data.name,
                            "artist": data.artist, "bigImageURL": data.bigImageURL, "smallImageURL": data.smallImageURL, "previewURL": data.previewURL, "genres": data.genres, "count": data.count - 1, "backgroundColors": data.backgroundColors, "dateList": data.dateList],
                    update: .modified
                )
            }
        } catch {
            
        }
    }
    
    // 추가한 날짜(오늘)을 MusicItemTable의 dateList에 추가해준다
    func plusDate(_ data: MusicItemTable, today: Date) {
        do {
            try realm.write {
                let todayString = today.toString(of: .full)
                data.dateList.append(todayString)
                
                realm.create(
                    MusicItemTable.self,
                    value: ["id": data.id, "name": data.name,
                            "artist": data.artist, "bigImageURL": data.bigImageURL, "smallImageURL": data.smallImageURL, "previewURL": data.previewURL, "genres": data.genres, "count": data.count, "backgroundColors": data.backgroundColors, "dateList": data.dateList],
                    update: .modified
                )
            }
        } catch {
            print("업데이트 에러")
        }
    }
    
    
    func minusDate(_ data: MusicItemTable, today: Date) {
        do {
            try realm.write {
                let todayString = today.toString(of: .full)
            
                guard let index = data.dateList.firstIndex(where: { $0 == todayString}) else { return }
                data.dateList.remove(at: index)
                
                
                realm.create(
                    MusicItemTable.self,
                    value: ["id": data.id, "name": data.name,
                            "artist": data.artist, "bigImageURL": data.bigImageURL, "smallImageURL": data.smallImageURL, "previewURL": data.previewURL, "genres": data.genres, "count": data.count, "backgroundColors": data.backgroundColors, "dateList": data.dateList],
                    update: .modified
                )
            }
        } catch {
            
        }
    }
    
    

    
    
    
}
