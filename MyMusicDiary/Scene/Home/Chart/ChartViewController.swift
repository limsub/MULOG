//
//  ChartViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit
import DGCharts


class ChartViewController: BaseViewController {
    
    
    // pie chart랑 bar chart랑 다른 데이터 사용함 (애초에 repository 가져올 때부터)
    // 단, 장르랄 색상은 맞춰주기 위해, bar chart에서 genres, colors 배열 접근해서 해당 장르가 어떤 색상인지는 확인하기

    // view
    let circleGraphView = CustomPieChartView()
    let barGraphView = CustomBarChartViewWithExplanation()
    
    
    // viewModel
    let repository = ChartDataRepository()
    
    // pie chart
    var genres: [String] = []
    var counts: [Double] = []
    var colors: [String] = []
    var percentArr: [Double] = []
    
    // bar chart
    var barData: [DayGenreCountForBarChart] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        
        fetchDataForPieChart(Date())
        fetchDataForBarChart(Date())
        
        /* circle Graph */
        // titleLabel
        circleGraphView.titleLabel.text = "과목별 비율"
        
        // pieChart
        settingCharts(dataPoints: genres, values: percentArr)
        
        // collectionView
        circleGraphView.collectionView.register(PieChartSideCollectionViewCell.self, forCellWithReuseIdentifier: PieChartSideCollectionViewCell.description())
        circleGraphView.collectionView.dataSource = self
        circleGraphView.collectionView.showsVerticalScrollIndicator = false

        
        /* bar Graph */
        // titleLabel
        barGraphView.titleLabel.text = "과목별 비율"
        
        //
        
        // collectionView
        barGraphView.collectionView.register(BarChartSideCollectionViewCell.self, forCellWithReuseIdentifier: BarChartSideCollectionViewCell.description())
        barGraphView.collectionView.dataSource = self
        barGraphView.collectionView.showsHorizontalScrollIndicator = false
        barGraphView.collectionView.backgroundColor = .clear
        
        
        
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(circleGraphView)
        view.addSubview(barGraphView)
        barGraphView.backgroundColor = .white
    }
    override func setConstraints() {
        super.setConstraints()
        
        circleGraphView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(300)
        }
        barGraphView.snp.makeConstraints { make in
            make.top.equalTo(circleGraphView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(400)
        }
    }
    
    
    func fetchDataForPieChart(_ date: Date) {
        
        let tuple = repository.fetchMonthGenreDataForPieChart("202310")

        genres = Array(tuple.0)
        counts = Array(tuple.1).map{ Double($0) }
        
        let cnt = tuple.0.count
        
        var sum: Double = 0
        counts.forEach { sum += $0 }
        counts.forEach { item in
            percentArr.append( (item/sum) * 100 )
        }
        print(percentArr)
        let tmpColors = UIColor.GenreColor.allCases.shuffled()
        for colorString in tmpColors {
            colors.append(colorString.rawValue)
        }
        print(tmpColors)
    }
    
    func fetchDataForBarChart(_ date: Date) {
        
        print("fetchDataForBarChart")
        barData = repository.fetchMonthGenreDataForBarChart("202310")
        
        barGraphView.barChartView.dataList = barData
        barGraphView.barChartView.type = .month
        barGraphView.barChartView.startDayString = "20231001"
        
        if true {
            barGraphView.barChartView.dayCount = calculateDayCnt("20231001")
        } else {
            barGraphView.barChartView.dayCount = 7
        }
        
        barGraphView.barChartView.genres = self.genres
        barGraphView.barChartView.colors = self.colors
    }
    
    
    func calculateDayCnt(_ starDayString: String) -> Int {
    
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: starDayString.toDate(to: .full) ?? Date())
        if let nextMonthDate = calendar.date(from: components),
           let lastDay = calendar.date(byAdding: DateComponents(day: -1), to: calendar.date(byAdding: DateComponents(month: 1), to: nextMonthDate)!) {

            return calendar.component(.day, from: lastDay)
        } else {
            return 30
        }
    }
    
    
    /* PieChartSideCollectionViewCell */
    func settingCharts(dataPoints: [String], values: [Double]) {

        var pieDataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let pieDataEntry = PieChartDataEntry(
                value: values[i],   // 차트 비율을 위한 값
                label: percentArr[i] < 8 ? nil : "\(Int(percentArr[i])) %" // 실제로 나타나는 값
            )
            pieDataEntries.append(pieDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieDataEntries)
        
        pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.colors = colors.map{ UIColor(hexCode: $0) }
        
        let pieData = PieChartData(dataSet: pieChartDataSet)
        circleGraphView.pieChartView.data = pieData

        circleGraphView.pieChartView.legend.enabled = false
    }
}




/* collectionView */
extension ChartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case circleGraphView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieChartSideCollectionViewCell.description(), for: indexPath) as? PieChartSideCollectionViewCell else { return UICollectionViewCell() }
            
            cell.colorImageView.backgroundColor = colors.map{ UIColor(hexCode: $0) }[indexPath.item]
                
            cell.nameLabel.text = genres[indexPath.item]
            cell.countLabel.text = "\(Int(counts[indexPath.item]))"
            cell.percentLabel.text = "\(Int(percentArr[indexPath.item])) %"
            
            return cell
            
        case barGraphView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarChartSideCollectionViewCell.description(), for: indexPath) as? BarChartSideCollectionViewCell else { return UICollectionViewCell() }
            
            cell.colorImageView.backgroundColor = colors.map{ UIColor(hexCode: $0) }[indexPath.item]
                
            cell.nameLabel.text = genres[indexPath.item]
           
            
            return cell
         
        default:
            return UICollectionViewCell()
        }

        
    }
}
