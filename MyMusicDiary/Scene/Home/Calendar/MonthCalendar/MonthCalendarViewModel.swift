//
//  CalendarViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import Foundation

class MonthCalendarViewModel {
    
    let repository = MusicItemTableRepository()
    
    var previousSelectedDate: Observable<Date> = Observable(Date())
    var currentSelectedDate: Observable<Date> = Observable(Date())  // 초기값 오늘
    
    var currentMusicList: Observable<[MusicItemTable]> = Observable([])
    
    
    // 캘린더 셀에 앨범아트 띄워주기 위함
    func fetchArtwork(_ date: Date, completionHandler: @escaping (URL?) -> Void) {

        if let data = repository.fetchDay(date), data.musicItems.count > 0, let smallURL = data.musicItems[0].smallImageURL, let url = URL(string: smallURL) {
            completionHandler(url)
        }
    }
    


    /* selected Date */
    func updateSelectedDate(_ newDate: Date) {  // 새로운 날짜로 업데이트
        previousSelectedDate.value = currentSelectedDate.value
        currentSelectedDate.value = newDate
    }
    
    func isCurrentSelected(_ date: Date) -> Bool {  // selected Date인지 체크
        // 전체 date로 비교하면 시간까지 비교하기 때문에, 필요한 연월일만 비교한다
        return currentSelectedDate.value.toString(of: .full) == date.toString(of: .full) ? true : false
    }
    
    
    /* music list */
    func updateMusicList() {
        currentMusicList.value.removeAll()
        guard let data = repository.fetchDay(currentSelectedDate.value) else { return }
        
        data.musicItems.forEach { item in
            currentMusicList.value.append(item)
        }
    }
}
