//
//  CalendarViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import Foundation

class CalendarViewModel {
    
    let repository = MusicItemTableRepository()
    
    var currentSelectedDate: Observable<Date> = Observable(Date())
    
    var musicList: Observable<DayItemTable>?
    
    func isCurrentSelected(_ date: Date) -> Bool {
        return (currentSelectedDate.value == date) ? true : false
    }
    
    func firstMusicUrl(_ date: Date) -> URL? {
        if let data = repository.fetchDay(date), let smallURL = data.musicItems[0].smallImageURL, let url = URL(string: smallURL) {
            return url
        } else {
            return nil
        }
    }
    
    func musicsForDate(_ date: Date) -> DayItemTable? {
        return repository.fetchDay(date)
    }
}
