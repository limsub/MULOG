//
//  ChartViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit
import DGCharts


// month
// 20231001
class MonthChartViewController: BaseViewController {


    let monthChartView = MonthChartView()
    
    
    // viewModel
    let viewModel = MonthChartViewModel()
//    let repository = ChartDataRepository()
    
//    // 공통 data
//    var currentPageDate = Date()
//    var genres: [String] = []
//    var colors: [String] = []
//
//    // title view
//    var musicTotalCnt = 0
//    var genreTotalCnt = 0
//
//    // pie chart
//    var counts: [Double] = []
//    var percentArr: [Double] = []
//
//    // bar chart
//    var barData: [DayGenreCountForBarChart] = []
    
    override func loadView() {
        self.view = monthChartView
    }
    
    @objc
    func prevButtonClicked() {
        if viewModel.changeCurrentPageDateByScroll(-1) {
            updateViews()
        }
    }
    
    @objc
    func nextButtonClicked() {
        // 다음 달로 넘겨준다 (미래 날짜로는 넘어가지 못한다)
        if viewModel.changeCurrentPageDateByScroll(+1) {
            updateViews()
        }
    }
    
    // 기간을 바꾸면, 아래 뷰들을 업데이트한다
    func updateViews() {
        viewModel.fetchDataForPieChart()  // 디비에 저장된 값을 통해 genres, counts, genresTotalCnt 로드
        viewModel.fetchDataForBarChart()  // 디비에 저장된 값을 통해 barData, musicTotalCnt 로드
        
        monthChartView.titleView.setView(
            startDay: viewModel.currentPageDate,
            musicCnt: viewModel.musicTotalCnt,
            genreCnt: viewModel.genreTotalCnt,
            type: .month
        )
        
        if viewModel.isZeroData() {
            monthChartView.setHiddenView(true)
        } else {
            monthChartView.setHiddenView(false)
            
            monthChartView.updatePieGraphView(
                dataPoints: viewModel.genres,
                values: viewModel.percentArr,
                colors: viewModel.colors
            )
            monthChartView.updateeBarGraphView(
                currentPageDate: viewModel.currentPageDate,
                barData: viewModel.barData,
                genres: viewModel.genres,
                colors: viewModel.colors
            )
            monthChartView.reloadViews()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.isDataChanged() {
            print("===== 값이 바뀌었다 =====")
            updateViews()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        
        /* 데이터 로드 */
        viewModel.initCurrentPageDate()   // currentPageDate (초기값: 오늘 날짜)를 이번 달 2일로 초기화한다
        
        updateViews()
        
        monthChartView.titleView.prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        monthChartView.titleView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        monthChartView.pieGraphView.collectionView.dataSource = self
        monthChartView.barGraphView.collectionView.dataSource = self
        
//        viewModel.fetchDataForPieChart()  // 디비에 저장된 값을 통해 genres, counts, genresTotalCnt 로드
//        viewModel.fetchDataForBarChart()  // 디비에 저장된 값을 통해 barData, musicTotalCnt 로드
        
        
        
        /* titleView */
//        monthChartView.titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .month)

        
//        if musicTotalCnt == 0 && genreTotalCnt == 0 {
//            monthChartView.setHiddenView(true)
//        } else  {
//            monthChartView.setHiddenView(true)
//        }
        
        // 얘는 그래도 viewDidLoad에서 최소한 해줘야 할 코드
        /* circle Graph */
//        settingPieGraphView(dataPoints: genres, values: percentArr)
        
        
//        monthChartView.pieGraphView.collectionView.showsVerticalScrollIndicator = false
//        monthChartView.pieGraphView.collectionView.reloadData()

        
        /* bar Graph */
//        settingBarGraphView()

        
//        monthChartView.barGraphView.collectionView.showsHorizontalScrollIndicator = false
//        monthChartView.barGraphView.collectionView.reloadData()
    }
    
//    func initCurrentPageDate() {
//        let calendar = Calendar.current
//        var component = calendar.dateComponents([.year, .month], from: currentPageDate)
//        component.day = 2
//        currentPageDate = calendar.date(from: component) ?? Date()
//    }
    
//    func fetchDataForPieChart(_ date: Date) {
//
//        let dateString = currentPageDate.toString(of: .yearMonth)
//        let tuple = repository.fetchMonthGenreDataForPieChart(dateString)
//
//        genres = Array(tuple.0)
//        counts = Array(tuple.1).map{ Double($0) }
//
//
//        var sum: Double = 0
//        percentArr.removeAll()
//        counts.forEach { sum += $0 }
//        counts.forEach { item in
//            percentArr.append( (item/sum) * 100 )
//        }
//        genreTotalCnt = Int(sum)
//
//        let tmpColors = UIColor.GenreColor.allCases
//        for colorString in tmpColors {
//            colors.append(colorString.rawValue)
//        }
//    }
    
    
//    func settingPieGraphView(dataPoints: [String], values: [Double]) {
//        // dataPoints : genres, values: percentArr
//
//        var pieChartDataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let pieDataEntry = PieChartDataEntry(
//                value: values[i],   // 차트 비율을 위한 값
//                label: percentArr[i] < 8 ? nil : "\(Int(percentArr[i])) %" // 실제로 나타나는 값
//            )
//            pieChartDataEntries.append(pieDataEntry)
//        }
//
//        let pieChartDataSet = PieChartDataSet(entries: pieChartDataEntries)
//        pieChartDataSet.highlightEnabled = false
//        pieChartDataSet.drawValuesEnabled = false
//        pieChartDataSet.colors = colors.map{ UIColor(hexCode: $0) }
//
//        let pieChartData = PieChartData(dataSet: pieChartDataSet)
//        monthChartView.pieGraphView.pieChartView.data = pieChartData
//    }
    
//    func fetchDataForBarChart() {
//        let dateString = currentPageDate.toString(of: .yearMonth)
//
//        let data = repository.fetchMonthGenreDataForBarChart(dateString)
//
//        barData = data.0
//        musicTotalCnt = data.1
//    }
    
//    func settingBarGraphView() {
//
//        let dateString = currentPageDate.toString(of: .full)
//
//        // 값 전달(?)
//        monthChartView.barGraphView.barChartView.dataList = barData
//        monthChartView.barGraphView.barChartView.startDayString = dateString
//        monthChartView.barGraphView.barChartView.dayCount = calculateDayCnt(dateString)
//
//        monthChartView.barGraphView.barChartView.genres = self.genres
//        monthChartView.barGraphView.barChartView.colors = self.colors
//    }

    }




/* collectionView */
extension MonthChartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genreNum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case monthChartView.pieGraphView.collectionView:
            print("pie==========")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieChartSideCollectionViewCell.description(), for: indexPath) as? PieChartSideCollectionViewCell else { return UICollectionViewCell() }
            
            
            cell.colorImageView.backgroundColor = viewModel.colorImageView(indexPath)
            cell.nameLabel.text = viewModel.nameLabel(indexPath)
            cell.countLabel.text = viewModel.countLabel(indexPath)
            cell.percentLabel.text = viewModel.percentLabel(indexPath)

            
            return cell
            
        case monthChartView.barGraphView.collectionView:
            print("bar==========")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarChartSideCollectionViewCell.description(), for: indexPath) as? BarChartSideCollectionViewCell else { return UICollectionViewCell() }
            
            cell.colorImageView.backgroundColor = viewModel.colorImageView(indexPath)
            cell.nameLabel.text = viewModel.nameLabel(indexPath)
            
            
            return cell
         
        default:
            
            print("default==========")
            return UICollectionViewCell()
        }

        
    }
    

}
