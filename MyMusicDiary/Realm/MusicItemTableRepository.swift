//
//  MusicItemTableRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/28.
//

import Foundation
import RealmSwift

class MusicItemTableRepository {
    
    private let realm = try! Realm()
    
    func createItem(_ item: MusicItemTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Create Error : ", error)
            // Alert : 데이터를 저장하는 과정에서 문제가 생겼습니다
        }
    }
    
    func fetch() -> Results<MusicItemTable> {
        let data = realm.objects(MusicItemTable.self)
        return data
    }
    
    func alreadySave(_ id: String) -> MusicItemTable? {
        let data = realm.objects(MusicItemTable.self).where {
            $0.id == id
        }
        
        return data.first
    }
    
    
    func plusCnt(_ value: [String: Any]) {
        do {
            try realm.write {
                realm.create(
                    MusicItemTable.self,
                    value: value,
                    update: .modified
                )
            }
        } catch {
            print("업데이트 에러")
        }
    }
}
