//
//  SaveViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation

class Sample {
    static let shared = Sample()
    
    var a = -15
}

enum SaveType {
    case modifyData
    case addData
}

class SaveViewModel {
    
    // 전달받을 데이터 1. 수정추가 enum, 2. 데이터 배열, 3. 날짜
    var saveType: SaveType? // 1.
    var preMusicList: Observable<[MusicItem]> = Observable([]) // 2.
    var currentDate: Date?  // 3.
    
    
    
    let repository = MusicItemTableRepository()
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    
    
    let genreList: [GenreType] = [.kpop, .pop, .ost, .hiphop, .rb]
    
    func numberOfItems() -> Int {
        return musicList.value.count
    }
    
    // '이전 날짜'의 데이터를 '수정'하러 들어온 상태인지 확인 -> 곡 추가 불가
    func impossibleAddMusic() -> Bool {
        if currentDate?.toString(of: .full) != Date().toString(of: .full)
            && saveType == .modifyData {
            return true
        }
        
        return false
    }
    
    
    
    // 값전달로 받은 preMusicList를 그대로 musicList에 저장
    func updateMusicList() {
        musicList.value = preMusicList.value
    }
    
    // 값전달로 받은 currentDate로 레이블에 나타날 텍스트 리턴
    func makeDateLabelString() -> String {
        guard let currentDate else { return "" }
        
        return "\(currentDate.toString(of: .monthYearKorean))의 음악 기록"
    }
    

    
    // 저장 버튼 클릭 - 10/16 로직 다시 짬
    func saveButtonClicked(
        emptyCompletionHandler: @escaping ( @escaping () -> Void, @escaping () -> Void ) -> Void,
        popViewCompletionHandler: @escaping () -> Void,
        duplicationCompletionHandler: () -> Void
    ) {
        print("========== 저장 버튼이 클릭되었습니다 ==========")
        
//        currentDate = Date()
    
        // 1. musicList가 빈 배열인지 확인
        if musicList.value.isEmpty {
            // 비었다 (삭제와 동일)
            print("=== 1. 음악 배열이 비었습니다. 얼럿 버튼 클릭에 따라 함수가 진행됩니다", terminator: " -> ")
            emptyCompletionHandler(
                // okClosure
                { [weak self] in// 얼럿 확인 -> 함수 진행
                    print("== 2. 확인 버튼을 눌렀습니다. 해당 날짜에 대한 데이터는 아무것도 저장되지 않습니다. 기존 데이터가 있었다면, 삭제합니다")
                    guard let date = self?.currentDate else { return }
                    
                    // 해당 날짜의 DayItemTable이 있는지 확인한다
                    if let alreadyItem = self?.repository.fetchDay(date) {
                        print("= 3. 해당 날짜의 데이터가 있습니다. 저장된 데이터를 모두 삭제합니다", terminator: " -> ")
                        // 있다
                        alreadyItem.musicItems.forEach { item in
                            self?.repository.minusCnt(item) // 1. 카운트 마이너스
                            self?.repository.minusDate(item, today: date) // 2. 날짜 마이너스
                        }
                        
                        self?.repository.deleteItem(alreadyItem)  // 3. 데이아이템 제거
                    }
                    
                    // 만약 해당 날짜가 오늘이라면, 알림을 다시 등록해줘야 한다
                    if date.toString(of: .full) == Date().toString(of: .full) {
                        print("= 3. 오늘 날짜의 데이터를 모두 삭제했습니다. 오늘 알림을 다시 켜줍니다. 켠 김에 싹 업데이트 시켜줍니다", terminator: " -> ")
                        NotificationRepository.shared.updateNotifications()
                    }
                    
                    print("===== 함수 종료 =====")
                    //다 지웠으면 더 추가할 곡이 없기 때문에 나가자
                    RealmDataModified.shared.modifyProperty.value.toggle()
                    popViewCompletionHandler()
                    return
                },
                // cancelClosure
                {// 얼럿 취소 -> 함수 종료 (return)
                    print("== 2. 취소 버튼을 눌렀습니다. 함수를 종료합니다")
                    return
                }
            )
            
        } else {
            // 안비었다 (데이터 수정 or 추가)
            print("=== 1. 음악 배열이 비어있지 않습니다. 중복된 데이터가 있는지 확인합니다", terminator: " -> ")
            
            // 1.5. 중복된 데이터가 있으면 얼럿 띄우고 함수 종료
            let list = musicList.value
            switch list.count {
            case 2:
                if list[0].id == list[1].id {
                    duplicationCompletionHandler()
                    print("== 2. 중복된 데이터가 있기 때문에 함수 종료")
                    return
                }
            case 3:
                if list[0].id == list[1].id || list[1].id == list[2].id || list[0].id == list[2].id {
                    duplicationCompletionHandler()
                    print("== 2. 중복된 데이터가 있기 때문에 함수 종료")
                    return
                }
            default:
                break
            }
            
            print("== 2. 중복된 데이터 없기 때문에 함수 계속 실행", terminator: " -> ")
            guard let date = currentDate else { return }
            
            
            // 해당 날짜의 DayItemTable 있는지 확인한다
            if let alreadyItem = repository.fetchDay(date) {
                print("= 3. 해당 날짜의 기존 데이터가 있습니다. 저장된 데이터를 모두 삭제합니다", terminator: " -> ")
                // 있어 -> 기존 데이터 제거
                alreadyItem.musicItems.forEach { item in
                    repository.minusCnt(item)   // 1.
                    repository.minusDate(item, today: date) // 2.
                }
                repository.deleteItem(alreadyItem)  // 3.
   
            }
            
            // 데이터 추가
            print("= 4. 새롭게 추가한 데이터를 저장합니다")
            let newTable = DayItemTable(day: date)
            
//            let a = Calendar.current.date(byAdding: .day, value: Sample.shared.a, to: Date())!
//            print("데이터 추가===============\(a)")
//            let newTable = DayItemTable(day: a)
//            Sample.shared.a += 2
            
            musicList.value.forEach {
                
                
                if let alreadyMusic = repository.alreadySave($0.id) {
                    // 기존에 저장했던 음악
                    print("= 5. \($0.name)은 기존에 저장해두었던 곡입니다. 원래 있던 MusicItem에 접근합니다")
                    repository.plusCnt(alreadyMusic)
                    repository.plusDate(alreadyMusic, today: date)
//                repository.plusDate(alreadyMusic, today: a)
                    repository.appendMusicItem(newTable, musicItem: alreadyMusic)
                } else {
                    // 새롭게 저장하는 음악
                    print("= 5. \($0.name)은 기존 다른 날짜에 저장하지 않았던 곡입니다. 새롭게 MusicItem을 생성합니다")
                    let newMusic = MusicItemTable(musicItem: $0)
                    newMusic.dateList.append(date.toString(of: .full))
//                newMusic.dateList.append(a.toString(of: .full))
                    repository.appendMusicItem(newTable, musicItem: newMusic)
                    
                }
                
            }
            
            
            // 오늘 날짜의 데이터를 새로 추가했으면, 오늘 알림은 제거해준다
            if date.toString(of: .full) == Date().toString(of: .full) {
                NotificationRepository.shared.delete(Date())
            }
            repository.createDayItem(newTable)
    
            // 데이터가 변했으므로, PagerView에 알려주기 위해 토글한다
            RealmDataModified.shared.modifyProperty.value.toggle()
            
            popViewCompletionHandler()
        }
        
        
        
    }
    
    
    
    // 데이터 추가 (저장 버튼 클릭)
    func addNewData(completionHandler: @escaping () -> Void, duplicationCompletionHandler: () -> Void) {
    
        // 진짜 만약에 음악 하나도 없는데 저장 버튼 눌렀다 -> 음악 추가하라고 얼럿
        if musicList.value.count == 0 {
            completionHandler()
            return
        }
        
        // 또 만약에, 서로 겹치는 음악을 저장하려고 한다 -> 안된다고 얼럿
        let list = musicList.value
        switch list.count {
        case 1:
            break
        case 2:
            if list[0].id == list[1].id {
                duplicationCompletionHandler()
                return
            }
        case 3:
            if list[0].id == list[1].id || list[1].id == list[2].id || list[0].id == list[2].id {
                duplicationCompletionHandler()
                return
            }
        default:
            break
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
        let todayTable = DayItemTable(day: Date())
        
//        let a = Calendar.current.date(byAdding: .day, value: Sample.shared.a, to: Date())!
//        print("데이터 추가===============\(a)")
//        let todayTable = DayItemTable(day: a)
//        Sample.shared.a += 2
        
        
        // 저장할 음악들
        musicList.value.forEach {
            // 기존에 저장했던 음악
            if let alreadyMusic = repository.alreadySave($0.id) {
                repository.plusCnt(alreadyMusic)
                
                repository.plusDate(alreadyMusic, today: Date())
//                repository.plusDate(alreadyMusic, today: a)
                
                repository.appendMusicItem(todayTable, musicItem: alreadyMusic)
            } else {    // 처음 저장하는 음악
                let newMusic = MusicItemTable(musicItem: $0)    // 램에 아직 없는 아이템
                
                newMusic.dateList.append(Date().toString(of: .full))
//                newMusic.dateList.append(a.toString(of: .full))
                
                repository.appendMusicItem(todayTable, musicItem: newMusic) // MusicItemTable에 자동 추가
            }
        }
        
        print("DayItemTable이 램에 저장됩니다", todayTable)
        
        repository.createDayItem(todayTable)
        
        // 데이터가 변화되었으므로, RealmDataModified 싱글톤 패턴의 변수에 알려준다
        RealmDataModified.shared.modifyProperty.value.toggle()  // -> 메인 페이저뷰의 pagerView reload
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
