//
//  ChartViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit
import DGCharts


class ChartViewController: BaseViewController {
    
    let repository = ChartDataRepository()
    
    let sub = MusicItemTableRepository()
    
    
    let circleGraphView = CustomPieChartView()
    
    
    var genres: [String] = []
    var counts: [Double] = []
    
    
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        
        
        let dict1 = repository.fetchMonthGenreData("202310")
//        let dict2 = repository.fetchWeekGenreData(startDate: "20231001", endDate: "20231031")
        
        genres = Array(dict1.keys)
        counts = Array(dict1.values).map{ Double($0) }
        
        
        // titleLabel
        circleGraphView.titleLabel.text = "과목별 비율"
        
        // pieChart
        settingCharts(dataPoints: genres, values: counts)
        
        
        
        // collectionView
        circleGraphView.collectionView.register(PieChartSideCollectionViewCell.self, forCellWithReuseIdentifier: PieChartSideCollectionViewCell.description())
        circleGraphView.collectionView.dataSource = self
        circleGraphView.collectionView.showsVerticalScrollIndicator = false
        
        
        
        
        
        
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(circleGraphView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        circleGraphView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(300)
        }
    }
    
    func settingCharts(dataPoints: [String], values: [Double]) {
//        var pieDataEntries: [ChartDataEntry] = []   // 그냥 ChartDataEntry 타입으로 하네?
//
//        for i in 0..<dataPoints.count {
//            let pieDataEntry = ChartDataEntry(x: Double(i), y: values[i])
//
//            pieDataEntries.append(pieDataEntry)
//        }
        
        var pieDataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let pieDataEntry = PieChartDataEntry(value: values[i], data: dataPoints[i] as AnyObject)
            
            pieDataEntries.append(pieDataEntry)
        }
        
        
        
        let pieChartDataSet = PieChartDataSet(entries: pieDataEntries, label: "우와아아아아아")
        
        pieChartDataSet.highlightEnabled = false
        
        
        let pieData = PieChartData(dataSet: pieChartDataSet)
        circleGraphView.pieChartView.data = pieData
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieData.setValueFormatter(formatter)
        
        circleGraphView.pieChartView.legend.enabled = false
        
        pieChartDataSet.colors = [.red, .blue, .purple, .cyan, .black]
    
    }
}





extension ChartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieChartSideCollectionViewCell.description(), for: indexPath) as? PieChartSideCollectionViewCell else { return UICollectionViewCell() }
            
        cell.nameLabel.text = genres[indexPath.item]
        cell.countLabel.text = "\(counts[indexPath.item])"
        cell.percentLabel.text = "70 %"
        
        return cell
    }
}
