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
    
    // data sort
    func sortDateList() {
        
    }
    
    // label
    func countText() -> String {
        guard let item else { return ""  }
        return "\(item.count)번 기록한 음악이에요"
    }
    
    func dateListText() -> String {
        guard let item else { return "기록 결과가 없습니다" }
        
        
        
        
        var ansTxt = "언제 기록했냐면"
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
        
        guard let dateString = item?.dateList[indexPath.item].toDate(to: .full)?.toString(of: .fullKorean) else { return ""}
        
        return dateString
    }
    
}
