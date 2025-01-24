//
//  RecordDateViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import Foundation


class RecordDateViewModel {
    
    var item: MusicItemTable?
    
    var dateList: [[String]] = []
    var sectionList: [String?] = []
    
    func setDataList() {
        
        var month = item?.dateList[0].substring(from: 0, to: 5)
        sectionList.append(month)
        var dayList: [String] = []
        var index = 0
        
        print("초기값 :", month, dayList, index)
        
        item?.dateList.forEach({ str in
            
            // 앞이랑 같은 month면 고대로 배열에 추가
            if str.substring(from: 0, to: 5) == month {
                dayList.append(str)
            }
            
            // 다른 month가 나왔으면 여태까지 저장한 리스트 dateList에 추가하고, 처음부터 다시 시작
            else {
                dateList.append(dayList)
                dayList.removeAll()
                
                month = str.substring(from: 0, to: 5)
                sectionList.append(month)
                dayList = [str]
                index += 1
            }
            
        })
        
        dateList.append(dayList)
        
        
        Logger.print("dateList : \(dateList)")
        Logger.print("sectionList : \(sectionList)")
    }
    
    // data sort
    func sortDateList() {
        
    }
    
    // label
    func countText() -> String {
        guard let item else { return ""  }
        return String(localized: "\(item.count)번 기록한 음악이에요 🎉")
    }
    
    func dateListText() -> String {
        guard let item else { return String(localized: "기록 결과가 없습니다") }
        
        var ansTxt = String(localized: "언제 기록했냐면")
        item.dateList.forEach { date in
            ansTxt += "\n"
            ansTxt += "\(date)"
        }
        return ansTxt
    }
    
    
    // collectionview
    func numberOfItems() -> Int{
        return item?.dateList.count ?? 0
    }
    
    func cellForItem(_ indexPath: IndexPath) -> String {

        guard let dateString = item?.dateList[indexPath.item].toDate(to: .full)?.toFullString() else { return "" }
        return dateString
    }
    
}
