//
//  SaveViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation

class SaveViewModel {
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    func numberOfItems() -> Int {
        return musicList.value.count
    }
}
