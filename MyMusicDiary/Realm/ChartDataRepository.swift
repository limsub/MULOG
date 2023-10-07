//
//  ChartDataRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import Foundation
import RealmSwift

class ChartDataRepository {
  
    
    let realm = try! Realm()
    
    func delete() {
        do {
            let item = realm.objects(DayItemTable.self).where{
                $0.day == "20231004"
            }
            
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("우와아아아아아아아아아아아아아아아아아아")
        }
    }
    
    
    /* ========== Pie Chart Data (날짜 저장 x) ========== */
        // 날짜 저장 x. 해당 기간의 총 데이터만 리턴
    
    // 해당 월에 등록한 음악들의 장르별 개수
    // input example: "202309"
    func fetchMonthGenreDataForPieChart(_ yearMonth: String) -> ([String], [Int]) {
        var ansDict: [String: Int] = [:]
        
        let data = realm.objects(DayItemTable.self).where {
            $0.day.contains(yearMonth)
        }
        
        
        for dayItem in data {
            let musicItems = dayItem.musicItems
            
            for musicItem in musicItems {
                let genres = musicItem.genres
                
                for genre in genres {
                    
                    // key가 존재하는지 확인하는 방법 -> key값을 넣었을 때 nil이 아니면 존재
                    if ansDict[genre] != nil {
                        ansDict[genre]? += 1    // 기존 value에서 1 추가
                    } else {
                        ansDict[genre] = 1      // 새로운 key - value 추가
                    }
                    
                }
            }
        }
        
        // "음악" key는 지워주기 -> * 다국어 대응
        ansDict["음악"] = nil
        
        let sortedDict = ansDict.sorted {  $0.value > $1.value }
        
        let sortedKeys = sortedDict.map { $0.key }
        let sortedValues = sortedDict.map { $0.value }
    
        return (sortedKeys, sortedValues)
    }
    
    
    
    // 해당 주에 등록한 음악들의 장르별 개수 -> 나중에는 직접 기간 입력할 수도 있게
    // input example : "20230901, 20230910"
//    func fetchWeekGenreData(startDate: String, endDate: String) -> Dictionary<String, Int> {
//
//        var ansDict: [String: Int] = [:]
//
//        // 주어진 날짜를 포함한, 사이에 있는 날짜들의 배열을 만든다
//        guard let startDateInt = Int(startDate), let endDateInt = Int(endDate) else { return ansDict }
//        if startDateInt > endDateInt { return ansDict }
//
//        let arrInt = Array(startDateInt...endDateInt)
//        let arrString = arrInt.map{ String($0) }
//
//
//        let data = realm.objects(DayItemTable.self).where {
//            $0.day.in(arrString)
//        }
//
//        for dayItem in data {
//            let musicItems = dayItem.musicItems
//
//            for musicItem in musicItems {
//                let genres = musicItem.genres
//
//                for genre in genres {
//
//                    if ansDict[genre] != nil {
//                        ansDict[genre]? += 1
//                    } else {
//                        ansDict[genre] = 1
//                    }
//                }
//            }
//        }
//
//        ansDict["음악"] = nil
//
//        return ansDict
//    }
    
    
    
    
    /* ========== Bar Chart Data ========== */
    func fetchMonthGenreDataForBarChart(_ yearMonth: String) -> ([DayGenreCountForBarChart],  Int) {
        
        var ansArr: [DayGenreCountForBarChart] = []
        var ansCnt = 0  // 총 음악 개수 리턴
        
        let data = realm.objects(DayItemTable.self).sorted(byKeyPath: "day").where {
            $0.day.contains(yearMonth)
        }
        
        for dayItem in data {
            
            let addDay = dayItem.day
            
            // 어떤 노래인지 상관x. 그냥 장르 별 개수만 리턴하기
            var addGenreCounts: [String : Int] = [:]
            dayItem.musicItems.forEach { musicItem in
                ansCnt += 1
                musicItem.genres.forEach { genre in
                    
                    if addGenreCounts[genre] != nil {
                        addGenreCounts[genre]? += 1
                    } else {
                        addGenreCounts[genre] = 1
                    }
                }
            }
            // * 다국어 대응
            addGenreCounts["음악"] = nil
            
            let addItem = DayGenreCountForBarChart(
                day: addDay,
                genreCounts: addGenreCounts
            )
            
            ansArr.append(addItem)
        }
        
        
        return (ansArr, ansCnt)
    }
}

struct DayGenreCountForBarChart {
    let day: String
    let genreCounts: [String: Int]
}
