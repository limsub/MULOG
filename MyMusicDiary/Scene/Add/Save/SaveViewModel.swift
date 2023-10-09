//
//  SaveViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation

class SaveViewModel {

    
    
    let repository = MusicItemTableRepository()
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    func numberOfItems() -> Int {
        return musicList.value.count
    }
    

    
    // 데이터 추가 (저장 버튼 클릭)
    func addNewData() {
        let todayTable = DayItemTable(day: Date())
        

//        let todayTable = DayItemTable(day: Calendar.current.date(byAdding: .day, value: -15, to: Date())!)
        
        
        
        // 저장할 음악들
        musicList.value.forEach {
            // 기존에 저장했던 음악
            if let alreadyMusic = repository.alreadySave($0.id) {
                repository.plusCnt(alreadyMusic)
                repository.plusDate(alreadyMusic, today: Date())
//                repository.plusDate(alreadyMusic, today: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
                repository.appendMusicItem(todayTable, musicItem: alreadyMusic)
            } else {    // 처음 저장하는 음악
                let newMusic = MusicItemTable(musicItem: $0)    // 램에 아직 없는 아이템
                newMusic.dateList.append(Date().toString(of: .full))
//                newMusic.dateList.append(Calendar.current.date(byAdding: .day, value: -2, to: Date())!.toString(of: .full))
                repository.appendMusicItem(todayTable, musicItem: newMusic) // MusicItemTable에 자동 추가
            }
        }
        
        print("DayItemTable이 램에 저장됩니다", todayTable)
        
        repository.createDayItem(todayTable)
    }
    
    func music(_ indexPath: IndexPath) -> MusicItem {
        return musicList.value[indexPath.row]
    }
    
    func musicRecordCount(_ indexPath: IndexPath) -> Int {
        let id = musicList.value[indexPath.row].id
        if let music = repository.fetchMusic(id) {
            return music.count
        } else {
            return 0
        }
    }
    
    func insertMusic(_ item: MusicItem, indexPath: IndexPath) {
        musicList.value.insert(item, at: indexPath.item)
    }
    func removeMusic(_ indexPath: IndexPath) {
        musicList.value.remove(at: indexPath.item)
    }
    func appendMusic(_ item: MusicItem) {
        musicList.value.append(item)
    }
    
    func musicListCount() -> Int {
        return musicList.value.count
    }
    
    
    
 
}
