//
//  SaveViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation

class Sample {
    static let shared = Sample()
    
    var a = -65
}

class SaveViewModel {
    
    let repository = MusicItemTableRepository()
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    var preMusicList: Observable<[MusicItem]> = Observable([])
    
    let genreList: [GenreType] = [.kpop, .pop, .ost, .hiphop, .rb]
    
    func numberOfItems() -> Int {
        return musicList.value.count
    }
    

    
    // 데이터 추가 (저장 버튼 클릭)
    func addNewData(completionHandler: @escaping () -> Void) {
        
        // 진짜 만약에 음악 하나도 없는데 저장 버튼 눌렀다 -> 음악 추가하라고 얼럿
        if musicList.value.count == 0 {
            completionHandler()
            return
        }
        
        // 만약 오늘 날짜의 데이터가 있다면 -> 수정하러 들어온 것
        // 1. 오늘 데이터 삭제하고, 1.5. musicitemtable의 datelist에서 오늘 날짜 빼주고,  2. 새로운 데이터 넣어준다
        
        // 1.
        if let alreadyTodayItem = repository.fetchDay(Date()) {
            
            
            // musicItemTable들의 count를 1 줄여준다
            alreadyTodayItem.musicItems.forEach { item in
                repository.minusCnt(item)
                repository.minusDate(item, today: Date())
            }
            
            
            
            
            // dayItemTable 자체를 없앤다
            repository.deleteItem(alreadyTodayItem)
        }
      
        
        
        // 2.
//        let todayTable = DayItemTable(day: Date())
        
        let a = Calendar.current.date(byAdding: .day, value: Sample.shared.a, to: Date())!
        print("데이터 추가===============\(a)")
        let todayTable = DayItemTable(day: a)
        Sample.shared.a += 1
        
        
        // 저장할 음악들
        musicList.value.forEach {
            // 기존에 저장했던 음악
            if let alreadyMusic = repository.alreadySave($0.id) {
                repository.plusCnt(alreadyMusic)
                
//                repository.plusDate(alreadyMusic, today: Date())
                repository.plusDate(alreadyMusic, today: a)
                
                repository.appendMusicItem(todayTable, musicItem: alreadyMusic)
            } else {    // 처음 저장하는 음악
                let newMusic = MusicItemTable(musicItem: $0)    // 램에 아직 없는 아이템
                
//                newMusic.dateList.append(Date().toString(of: .full))
                newMusic.dateList.append(a.toString(of: .full))
                
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
    
    
    
    
    // 장르 컬렉션뷰
    func genreListCount() -> Int {
        return genreList.count
    }
    func genreName(indexPath: IndexPath) -> String {
        return genreList[indexPath.item].koreanName
    }
    func genreColorName(indexPath: IndexPath) -> String {
        return genreList[indexPath.item].colorHexCode
    }
 
}
