//
//  SaveViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation

class Sample {
    static let shared = Sample()
    
    var a = -10
}

enum SaveType {
    case modifyData
    case addData
    
    var descriptionForLog: String {
        switch self {
        case .modifyData:
            return "기록 수정"
        case .addData:
            return "기록 추가"
        }
    }
}


class SaveViewModel {
    
    // 전달받을 데이터 1. 수정추가 enum, 2. 데이터 배열, 3. 날짜
    var saveType: SaveType? // 1.
    var preMusicList: CustomObservable<[MusicItem]> = CustomObservable([]) // 2.
    var currentDate: Date?  // 3.
    

    let repository = MusicItemTableRepository()
    
    var musicList: CustomObservable<[MusicItem]> = CustomObservable([])
}


// MARK: - func called from VC
extension SaveViewModel {
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
    
    func music(_ indexPath: IndexPath) -> MusicItem {
        return musicList.value[indexPath.row]
    }
    
    func numberOfItems() -> Int {
        return musicList.value.count
    }
    
    func updateMusicList() {
        // 값전달로 받은 preMusicList를 그대로 musicList에 저장
        musicList.value = preMusicList.value
    }
    
    func saveButtonClicked(
        emptyCompletionHandler: @escaping ( @escaping () -> Void, @escaping () -> Void ) -> Void,
        popViewCompletionHandler: @escaping () -> Void,
        duplicationCompletionHandler: () -> Void
    ) {
        Logger.print("========== 저장 버튼이 클릭되었습니다 ==========")
        
        // Check empty list
        if musicList.value.isEmpty {
            Logger.print("=== 1. 음악 배열이 비었습니다. 얼럿 버튼 클릭에 따라 함수가 진행됩니다", terminator: " -> ")
            emptyCompletionHandler(
                // OK
                { [weak self] in
                    print("== 2. 확인 버튼을 눌렀습니다. 해당 날짜에 대한 데이터는 아무것도 저장되지 않습니다. 기존 데이터가 있었다면, 삭제합니다")
                    guard let date = self?.currentDate else { return }
                    
                    // Check Already Record
                    // 1. Delete data for current date
                    // 2. Delete current date from MusicItemTable (delete data. minus count)
                    if let alreadyItem = self?.repository.fetchDay(date) {
                        print("= 3. 해당 날짜의 데이터가 있습니다. 저장된 데이터를 모두 삭제합니다", terminator: " -> ")
                        // 2.
                        alreadyItem.musicItems.forEach { item in
                            self?.repository.minusCnt(item)
                            self?.repository.minusDate(item, today: date)
                        }
                        
                        // 1.
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
                
                // CANCEL
                {
                    print("== 2. 취소 버튼을 눌렀습니다. 함수를 종료합니다")
                    return
                }
            )
        } else {
            print("=== 1. 음악 배열이 비어있지 않습니다. 중복된 데이터가 있는지 확인합니다", terminator: " -> ")
            // Check duplicated data
            if (checkDuplicateMusic(musicList.value)) {
                duplicationCompletionHandler()
                print("== 2. 중복된 데이터가 있기 때문에 함수 종료")
                return
            }

            print("== 2. 중복된 데이터 없기 때문에 함수 계속 실행", terminator: " -> ")
            guard let date = currentDate else { return }
            
            
            // Check Already Record
            // 1. Delete data for current date
            // 2. Delete current date from MusicItemTable (delete data. minus count)
            if let alreadyItem = repository.fetchDay(date) {
                print("= 3. 해당 날짜의 기존 데이터가 있습니다. 저장된 데이터를 모두 삭제합니다", terminator: " -> ")
                // 2.
                alreadyItem.musicItems.forEach { item in
                    repository.minusCnt(item)
                    repository.minusDate(item, today: date)
                }
                // 1.
                repository.deleteItem(alreadyItem)
   
            }
            
            // Add new data
            print("= 4. 새롭게 추가한 데이터를 저장합니다")
            let newTable = DayItemTable(day: date)
            
            musicList.value.forEach {
                if let alreadyMusic = repository.alreadySave($0.id) {
                    // 기존에 저장했던 음악
                    print("= 5. \($0.name)은 기존에 저장해두었던 곡입니다. 원래 있던 MusicItem에 접근합니다")
                    repository.plusCnt(alreadyMusic)
                    repository.plusDate(alreadyMusic, today: date)
                    repository.appendMusicItem(newTable, musicItem: alreadyMusic)
                } else {
                    // 새롭게 저장하는 음악
                    print("= 5. \($0.name)은 기존 다른 날짜에 저장하지 않았던 곡입니다. 새롭게 MusicItem을 생성합니다")
                    let newMusic = MusicItemTable(musicItem: $0)
                    newMusic.dateList.append(date.toString(of: .full))
                    repository.appendMusicItem(newTable, musicItem: newMusic)
                }
            }
            repository.createDayItem(newTable)
            
            // Delete local noti if today's data added
            deleteNotiIfTodayDataAdded(date)
            
            // Noti for PagerView (toggle)
            RealmDataModified.shared.modifyProperty.value.toggle()
            
            popViewCompletionHandler()
            
            return;
        }
    }
}


// MARK: - private func
extension SaveViewModel {
    // 레이블에 나타날 텍스트 리턴
    func makeDateLabelString() -> String {
        guard let currentDate else { return "" }
        return String(localized: "\(currentDate.toMonthDayStringLocalized())의 음악 기록")
    }
    
    // 중복된 음악 있는지 체크
    private func checkDuplicateMusic(_ arr: [MusicItem]) -> Bool {
        var seen: Set<String> = []
        for id in arr.map { $0.id } {
            if seen.contains(id) {
                return true
            }
            seen.insert(id)
        }
        return false
    }
    
    // 오늘 날짜의 데이터를 추가했다면, 오늘 알림은 제거
    private func deleteNotiIfTodayDataAdded(_ date: Date) {
        // 오늘 날짜의 데이터를 새로 추가했으면, 오늘 알림은 제거해준다
        if date.toString(of: .full) == Date().toString(of: .full) {
            NotificationRepository.shared.delete(Date())
        }
    }
}
