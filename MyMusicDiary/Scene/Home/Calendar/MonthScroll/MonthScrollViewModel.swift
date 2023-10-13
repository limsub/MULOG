//
//  MonthScrollViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/05.
//

import Foundation


class MonthScrollViewModel {

    let repository = MusicItemTableRepository()
    
    let allYear = Array(2020...2030)
    let allMonth = Array(1...12)
    
    var data: Observable<[DayItemTable]> = Observable([])
    
    var currentPageDate = Date()
    
    var isPickerViewHidden = true
    
    /* isPickerViewHidden */
    func pickerViewHiddenState() -> Bool {
        return isPickerViewHidden
    }

    func togglePickerViewHidden() { // pickerView 접혔다 펼쳤다
        isPickerViewHidden.toggle()
    }
    
    /* pickerView + title */
    // currentPageData로 pickerView에 선택되어있어야 할 인덱스 리턴
    func currentMonthIdx() -> Int {
        guard let month = Int(currentPageDate.toString(of: .singleMonth)) else { return 0}
        guard let selectedMonthIndex = allMonth.firstIndex(of: month) else { return 0 }
        return selectedMonthIndex
    }
    
    func currentYearIdx() -> Int {
        guard let year = Int(currentPageDate.toString(of: .year)) else { return 0 }
        guard let selectedYearIndex = allYear.firstIndex(of: year) else { return 0 }
        return selectedYearIndex
    }
    
    
    // 타이틀에 적혀있어야 하는 월/연
    func currentMonthYearTitle() -> String {
        return currentPageDate.toString(of: .fullMonthYear)
    }
    
    
    
    
    
    // currentPageDate로 해당 연월에 맞는 새로운 데이터 로드
    func updateData() {
        let yearMonth = currentPageDate.toString(of: .yearMonth)
        
        if let newData = repository.fetchMonth(yearMonth) {
            data.value = newData
        } else {
            data.value.removeAll()
        }
    }
    
    
 
    
    
    /* collectionView DataSource */
    func numberOfSections() -> Int {
        return data.value.count
    }
    func numberOfItemsInSection(_ section: Int) -> Int {
        return data.value[section].musicItems.count
    }
    func cellForItemData(_ indexPath: IndexPath) -> MusicItemTable {
        return data.value[indexPath.section].musicItems[indexPath.item]
    }
    func cellForItemDay(_ indexPath: IndexPath) -> String {
        return data.value[indexPath.section].day
    }
    
    
    /* pickerView DataSource Delegate */
    func numberOfRowsInComponent(_ component: Int) -> Int {
        switch component {
        case 0:
            return allMonth.count
        case 1:
            return allYear.count
        default:
            return 0
        }
    }
    func titleForRow(row: Int, component: Int) -> String? {
        switch component {
        case 0:
            // allMonth -> 8, 9, 10, 11 => MM으로 만들어줘야 함 (int -> String -> date)
            // MM => MMMM으로 만들어줘야 함 (date -> string)
            let month = allMonth[row]   // Int
            let monthString = (month < 10) ? "0\(month)" : "\(month)"   // String
            let monthDate = monthString.toDate(to: .month)  // Date
            let ansString = monthDate?.toString(of: .fullMonth) // String
            return ansString
        case 1:
            return String(allYear[row])
        default:
            return ""
        }
    }
    func didSelectRow(row: Int, component: Int) -> String {
        // 1. currentPageDate 업데이트      -> 함수 내에서 끝
        // 2. titleButton setTitle        -> 리턴값
        
        // 1.
        // currentPageDate로 초기값 지정
        guard let tmpYear = Int(currentPageDate.toString(of: .year)) else { return "" }
        guard let tmpMonth = Int(currentPageDate.toString(of: .singleMonth)) else { return "" }
        
        var selectedMonth = tmpMonth
        var selectedYear = tmpYear
        
        switch component {
        case 0:
            selectedMonth = allMonth[row]
        case 1:
            selectedYear = allYear[row]
        default:
            break
        }
        
        let dateString = (selectedMonth < 10) ? "\(selectedYear)0\(selectedMonth)" : "\(selectedYear)\(selectedMonth)"
        guard let newDate = dateString.toDate(to: .yearMonth) else { return "" }   // Date
        currentPageDate = newDate
        
        // 2.
        let newTitle = newDate.toString(of: .fullMonthYear)
        return newTitle
    }
    func attributedTitleForRow(row: Int, component: Int) -> String? {
        switch component {
        case 0:
            // allMonth -> 8, 9, 10, 11 => MM으로 만들어줘야 함 (int -> String -> date)
            // MM => MMMM으로 만들어줘야 함 (date -> string)
            let month = allMonth[row]   // Int
            let monthString = (month < 10) ? "0\(month)" : "\(month)"   // String
            let monthDate = monthString.toDate(to: .month)  // Date
            let ansString = monthDate?.toString(of: .fullMonth) // String
            
            return ansString
        case 1:
            return String(allYear[row])
        default:
            return ""
        }
    }
    
}
