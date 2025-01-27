//
//  SummaryMonthVM.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/26/25.
//

import Foundation
import ReactorKit
import RealmSwift
import RxSwift
import RxCocoa

class SummaryMonthReactor: Reactor {
    
    let repo = SummaryRepository()
    
    enum Action {
        case goBefore
        case goAfter
        case reload
    }
    
    enum Mutation {
        case setCurrentMonth(String)
        case setCurrentMonthWholeData([String])
        case setSelectedData([String])
        case pass
    }
    
    struct State {
        var currentMonth: String = Date().toString(of: .yearMonth)   // yyyyMM
        var currentMonthWholeData: [String] = []    // 해당 월의 모든 이미지 배열
        var selectedData: [String] = []             // 최대 50개 배열
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .goBefore:
            let curMonth = currentState.currentMonth
            let newMonth = self.minusMonth(curMonth)
            let newWholeData = repo.fetchMonthImageList(newMonth)
            let newSelectedData = self.pick50Data(newWholeData)
            return .concat([
                .just(.setCurrentMonth(newMonth)),
                .just(.setCurrentMonthWholeData(newWholeData)),
                .just(.setSelectedData(newSelectedData))
            ])
            return .just(.pass)
        case .goAfter:
            let curMonth = currentState.currentMonth
            let newMonth = self.addMonth(curMonth)
            let newWholeData = repo.fetchMonthImageList(newMonth)
            let newSelectedData = self.pick50Data(newWholeData)
            return .concat([
                .just(.setCurrentMonth(newMonth)),
                .just(.setCurrentMonthWholeData(newWholeData)),
                .just(.setSelectedData(newSelectedData))
            ])
            
        case .reload:
            let curMonth = currentState.currentMonth
            let curData = currentState.currentMonthWholeData
            let newSelectedData = self.pick50Data(curData)
            return .just(.setSelectedData(newSelectedData))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentMonth(let month):
            print(month)
            
        case .setCurrentMonthWholeData(let list):
            print(list)
            
        case .setSelectedData(let list):
            print(list)
            
        case .pass:
            print("pass")
        }
        
        return newState
    }
}

extension SummaryMonthReactor {
    private func addMonth(_ yearMonth: String) -> String {
        if let date = yearMonth.toDate(to: .yearMonth),
           let newDate = Calendar.current.date(byAdding: .month, value: 1, to: date) {
            return newDate.toString(of: .yearMonth)
        }
        return Date().toString(of: .yearMonth)
    }
    
    private func minusMonth(_ yearMonth: String) -> String {
        if let date = yearMonth.toDate(to: .yearMonth),
           let newDate = Calendar.current.date(byAdding: .month, value: -1, to: date) {
            return newDate.toString(of: .yearMonth)
        }
        return Date().toString(of: .yearMonth)
    }
    
    private func pick50Data(_ arr: [String]) -> [String] {
        if arr.count <= 50 {
            return arr.shuffled()
        } else {
            return Array(arr.shuffled().prefix(50))
        }
    }
}


class SummaryRepository {
    let realm = try! Realm()
    
    func fetchMonthImageList(_ yearMonth: String) -> [String] {
        let data = realm.objects(DayItemTable.self).where {
            $0.day.contains(yearMonth)
        }
        
        var imageList: [String] = []
        for dayItem in data {
            for music in dayItem.musicItems {
                imageList.append(music.bigImageURL ?? "")
            }
        }
        
        return imageList
    }
}
