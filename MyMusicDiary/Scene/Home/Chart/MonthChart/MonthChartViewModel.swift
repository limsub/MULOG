//
//  MonthChartViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import UIKit

class MonthChartViewModel {
    
    let repository = ChartDataRepository()
    
    // 공통 data
    var currentPageDate = Date()
    var genres: [String] = []
    var colors: [String] = []
    
    // title view
    var musicTotalCnt = 0
    var genreTotalCnt = 0
    
    // pie chart
    var counts: [Double] = []
    var percentArr: [Double] = []
    
    // bar chart
    var barData: [DayGenreCountForBarChart] = []
    
    
    
    // 맨 처음 currentPageDate 설정 (해당 달 2일)
    func initCurrentPageDate() {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month], from: currentPageDate)
        component.day = 2
        currentPageDate = calendar.date(from: component) ?? Date()
    }
    
    // 달이 이동할 때, (캘린더 좌우 스크롤) currentPageDate 새로 계산
    func changeCurrentPageDateByScroll(_ value: Int) -> Bool {
        let calendar = Calendar.current
        guard let component = calendar.date(byAdding: .month, value: value, to: currentPageDate) else { return false }
        if component > Date() { return false }
        
        currentPageDate = component
        return true
    }
    func isCurrentPageDateGoFuture() -> Bool {
        return (currentPageDate > Date())
    }
    
    // pie chart를 위한 데이터 fetch
    func fetchDataForPieChart() {
        let date = currentPageDate
        
        let dateString = currentPageDate.toString(of: .yearMonth)
        let tuple = repository.fetchMonthGenreDataForPieChart(dateString)

        genres = Array(tuple.0)
        counts = Array(tuple.1).map{ Double($0) }
        
        
        var sum: Double = 0
        percentArr.removeAll()
        counts.forEach { sum += $0 }
        counts.forEach { item in
            percentArr.append( (item/sum) * 100 )
        }
        genreTotalCnt = genres.count // Int(sum)

        let tmpColors = UIColor.GenreColor.allCases
        for colorString in tmpColors {
            colors.append(colorString.rawValue)
        }
    }
    
    // bar chart를 위한 데이터 fetch
    func fetchDataForBarChart() {
        let dateString = currentPageDate.toString(of: .yearMonth)

        let data = repository.fetchMonthGenreDataForBarChart(dateString)
        
        barData = data.0
        musicTotalCnt = data.1
    }
    
    // 0, 0인지 확인
    func isZeroData() -> Bool {
        return (musicTotalCnt == 0 && genreTotalCnt == 0)
    }
    
    // fetch 와 동일하게 데이터를 읽어오는데, 기존 데이터와 달라졌는지 확인. 달라졌으면 true
    func isDataChanged() -> Bool {
        let dateString = currentPageDate.toString(of: .yearMonth)
        let maybeNewTuple = repository.fetchMonthGenreDataForPieChart(dateString)
        
        return genres != Array(maybeNewTuple.0)
                || counts != Array(maybeNewTuple.1).map { Double($0) }
    }
}


/* collectionView */
extension MonthChartViewModel {
    
    func genreNum() -> Int {
        return genres.count
    }
    
    func colorImageView(_ indexPath: IndexPath) -> UIColor {
        return colors.map{ UIColor(hexCode: $0) }[indexPath.item]
    }
    func nameLabel(_ indexPath: IndexPath) -> String {
        return genres[indexPath.item]
    }
    func countLabel(_ indexPath: IndexPath) -> String {
        return "\(Int(counts[indexPath.item]))"
    }
    func percentLabel(_ indexPath: IndexPath) -> String {
        return "\(Int(percentArr[indexPath.item])) %"
    }
}
