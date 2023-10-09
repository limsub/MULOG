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
    
//    var musicList: Observable<DayItemTable>?
    
    func isCurrentSelected(_ date: Date) -> Bool {
        return (currentSelectedDate.value == date) ? true : false
    }
    
    func firstMusicUrl(_ date: Date) -> URL? {

        if let data = repository.fetchDay(date), data.musicItems.count > 0, let smallURL = data.musicItems[0].smallImageURL, let url = URL(string: smallURL) {
            return url
        } else {
            return nil
        }
    }
    
//    func musicsForDate(_ date: Date) -> DayItemTable? {
//        return repository.fetchDay(date)
//    }
    
    func updateMusicList(_ date: Date) {
        currentMusicList.value.removeAll()
        
        guard let data = repository.fetchDay(date) else { return }
        
        data.musicItems.forEach { item in
            currentMusicList.value.append(item)
        }
    }
    
    func updateSelectedDate(_ newDate: Date) {
        previousSelectedDate.value = currentSelectedDate.value
        currentSelectedDate.value = newDate
    }
}
