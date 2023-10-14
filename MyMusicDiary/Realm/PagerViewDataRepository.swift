//
//  PagerViewDataRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import Foundation
import RealmSwift


class PagerViewDataRepository {
    
    let realm = try! Realm()
    
    
    // 램에 저장된 MusicTable을 훑으면서
    // 랜덤으로 데이터를 가져옴? 가져와서 랜덤으로 돌림?
    
    // 일단 가져와서 돌리자. 모든 데이터 다 가져와서 랜덤 돌리고, 최대 30개까지만 가져올 수 있도록 함
    
    func fetchMusicForPagerView() -> [MusicItemTable] {    // nil이면 "없다" 화면 보여주기
        let data = realm.objects(MusicItemTable.self).where {
            $0.count > 0
        }
        
        let dataArray = Array(data).shuffled()
        
        if dataArray.count > 30 {
            return Array(dataArray[0...29])
        } else {
            return dataArray
        }
    }
}
