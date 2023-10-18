//
//  WeekChartViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import UIKit

class WeekChartViewModel {
    
    // viewModel
    let repository = ChartDataRepository()
    
    // 공통 data
    var currentPageDate = Date()
    var endDate = Date()
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
    
    
    func initCurrentPageDateEndDate() {
        guard let tuple = DateFormatType.getStartAndEndDateOfWeek(for: currentPageDate) else { return }
        currentPageDate = tuple.0
        endDate = tuple.1
    }
    
    func changeCurrentPageDateEndDateByScroll(_ value: Int) -> Bool {
        let calendar = Calendar.current
        guard let startComponent = calendar.date(byAdding: .day, value: value, to: currentPageDate) else { return false }
        guard let endComponent = calendar.date(byAdding: .day, value: value, to: endDate) else { return false }
        if startComponent > Date() { return false }
        
        currentPageDate = startComponent
        endDate = endComponent
        print(currentPageDate)
        
        return true
    }
    
    func fetchDataForPieChart() {
        let startDateString = currentPageDate.toString(of: .full)
        let endDateString = endDate.toString(of: .full)
        
        let tuple = repository.fetchWeekGenreDataForPieChart(startDate:startDateString, endDate: endDateString)
        
        genres = Array(tuple.0)
        counts = Array(tuple.1).map{ Double($0) }
        
        
        var sum: Double = 0
        percentArr.removeAll()
        counts.forEach { sum += $0 }
        counts.forEach { item in
            percentArr.append( (item/sum) * 100 )
        }
        genreTotalCnt = Int(sum)

        let tmpColors = UIColor.GenreColor.allCases
        for colorString in tmpColors {
            colors.append(colorString.rawValue)
        }
    }
    
    func fetchDataForBarChart() {
        let startDateString = currentPageDate.toString(of: .full)
        let endDateString = endDate.toString(of: .full)

        let data = repository.fetchWeekGenreDataForBarChart(startDate: startDateString, endDate: endDateString)
        
        barData = data.0
        musicTotalCnt = data.1
    }
    
    func isZeroData() -> Bool {
        return (musicTotalCnt == 0 && genreTotalCnt == 0)
    }
    
    // fetch와 동일하게 데이터를 읽어오지만, 기존 데이터와 달라졌는지 확인. 달라졌으면 true
    func isDataChanged() -> Bool {
        let startDateString = currentPageDate.toString(of: .full)
        let endDateString = endDate.toString(of: .full)
        let tuple = repository.fetchWeekGenreDataForPieChart(startDate:startDateString, endDate: endDateString)
        
        return genres != Array(tuple.0) || counts != Array(tuple.1).map { Double($0) }
    }
}
