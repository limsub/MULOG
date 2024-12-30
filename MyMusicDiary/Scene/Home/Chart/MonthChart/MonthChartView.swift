//
//  MonthChartView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import UIKit
import DGCharts


class MonthChartView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleView = CustmTitleView()
    let pieGraphView = CustomPieChartView()
    var barGraphView = CustomBarChartViewWithExplanation()
    
    
    override func setConfigure() {
        super.setConfigure()
    
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleView)
        contentView.addSubview(pieGraphView)
        contentView.addSubview(barGraphView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(46)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8) // tabman의 bar를 custom으로 잡았다
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.height.equalTo(130)
        }
        pieGraphView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.height.equalTo(300)
        }
        barGraphView.snp.makeConstraints { make in
            make.top.equalTo(pieGraphView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(14)
            make.height.equalTo(370)
            make.bottom.equalTo(contentView).inset(12)
        }
    }
    override func setting() {
        super.setting()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        barGraphView.backgroundColor = .white
        
        
        pieGraphView.titleLabel.text = String(localized: "전체 장르 비율")
        barGraphView.titleLabel.text = String(localized: "날짜별 장르 비율")
        
        pieGraphView.collectionView.register(PieChartSideCollectionViewCell.self, forCellWithReuseIdentifier: PieChartSideCollectionViewCell.description())
        barGraphView.collectionView.register(BarChartSideCollectionViewCell.self, forCellWithReuseIdentifier: BarChartSideCollectionViewCell.description())
        
        
        pieGraphView.pieChartView.legend.enabled = false
        
        pieGraphView.collectionView.showsVerticalScrollIndicator = false
        barGraphView.collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    
    func setHiddenView(_ value: Bool) {
        pieGraphView.isHidden = value
        barGraphView.isHidden = value
    }
    
    func reloadViews() {
        barGraphView.barChartView.setNeedsDisplay()
        pieGraphView.collectionView.reloadData()
        barGraphView.collectionView.reloadData()
    }
    
    
    
    func updatePieGraphView(dataPoints: [String], values: [Double], colors: [String]) {
        
        var pieChartDataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let pieDataEntry = PieChartDataEntry(
                value: values[i],   // 차트 비율을 위한 값
                label: values[i] < 8 ? nil : "\(Int(values[i])) %" // 실제로 나타나는 값
            )
            pieChartDataEntries.append(pieDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieChartDataEntries)
        pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.colors = colors.map{ UIColor(hexCode: $0) }
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieGraphView.pieChartView.data = pieChartData
    }
    
    func updateeBarGraphView(currentPageDate: Date, barData: [DayGenreCountForBarChart], genres: [String], colors: [String]) {
        
        let dateString = currentPageDate.toString(of: .full)
        
        // 값 전달(?)
        barGraphView.barChartView.dataList = barData
        barGraphView.barChartView.startDayString = dateString
        barGraphView.barChartView.dayCount = DateFormatType.calculateDayCnt(dateString)
        
        barGraphView.barChartView.genres = genres
        barGraphView.barChartView.colors = colors
        
        barGraphView.barDateView.reDesign(.month, startDate: currentPageDate)
    }
    
    
}
