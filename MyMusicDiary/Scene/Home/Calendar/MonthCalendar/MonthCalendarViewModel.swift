//
//  CalendarViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import Foundation
import RxSwift


class MonthCalendarViewModel {
    
    // 오늘 날짜 변화 감지
//    let todayDateString = BehaviorSubject(value: Date().toString(of: .full))
    
    
    
    
    let repository = MusicItemTableRepository()
    
    var previousSelectedDate: Observable<Date> = Observable(Date())
    var currentSelectedDate: Observable<Date> = Observable(Date())  // 초기값 오늘
    
    var currentMusicList: Observable<[MusicItemTable]> = Observable([])
    
    
    // 해당 날짜의 artwork url 받아옴
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
    
    func updateBeforeSelectedDate() {
        print("셀렉티드 데이 변경 전 : ", currentSelectedDate.value.convertedDate)
        guard let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentSelectedDate.value) else { return }
        previousSelectedDate.value = currentSelectedDate.value
        currentSelectedDate.value = newDate
        
        print("셀렉티드 데이 변경 : ", currentSelectedDate.value.convertedDate)
    }
    func updateAfterSelectedDate() {
        print("셀렉티드 데이 변경 전 : ", currentSelectedDate.value.convertedDate)
        // 오늘 날짜에서는 플러스 시킬 수 없다
        if isCurrentSelected(Date()) { return }
        
        guard let newDate = Calendar.current.date(byAdding: .day, value: +1, to: currentSelectedDate.value) else { return }
        previousSelectedDate.value = currentSelectedDate.value
        currentSelectedDate.value = newDate
        
        print("셀렉티드 데이 변경 : ", currentSelectedDate.value.convertedDate)
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
    
    // 오늘 날짜의 일기가 있는지 체크
    func isTodayWritten() -> Bool {
        if let todayDate = repository.fetchDay(Date()) {
//            repository.deleteItem(todayDate)
            return true
        } else {
            return false
        }
    }
    
    // currentedSelectedDate이 오늘인지
    func showModifyButton(completionHandler: @escaping (Bool) -> Void) {
        var isToday = currentSelectedDate.value.toString(of: .full) == Date().toString(of: .full)
        completionHandler(isToday)
    }
    
    
    // 함수 좀 다시 만들어보자
    // 선택된 날짜에 일기가 있으면 true, 없으면 false
    func isCurrentSelectedDateHaveData() -> Bool {
        if let selectedDateData = repository.fetchDay(currentSelectedDate.value) {
            
//            repository.deleteItem(selectedDateData)
            return true
        }
        
        return false
    }
    
    // 선택된 날짜가 오늘이면 true, 아니면 false (미래 날짜는 선택 못할거니까 이전 날짜)
    func isCurrentSelectedDateToday() -> Bool {
        return currentSelectedDate.value.toString(of: .full) == Date().toString(of: .full)
    }
    
    
}


// 24.07.16 인스타 스토리 공유하기
extension MonthCalendarViewModel {
    func dataForInstaStory() -> InstaStoryData? {
        guard let data = currentMusicList.value.first else { return nil }
        
        return InstaStoryData(
            date: currentSelectedDate.value,
            imageURL: data.bigImageURL!,
            title: data.name,
            artist: data.artist,
            genres: data.genres.map { $0 }
        )
    }
}
