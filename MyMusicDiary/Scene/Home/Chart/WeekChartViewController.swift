//
//  WeekChartViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit
import DGCharts

// week
// 20231001 - 20231007
// currentPageDate를 첫날로 유지하자
class WeekChartViewController: BaseViewController {
    
    var delegate: LargeTitleDelegate?

    // view
    let titleView = CustmTitleView()
    let pieGraphView = CustomPieChartView()
    var barGraphView = CustomBarChartViewWithExplanation()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
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
    
    
    
    // 주의 첫날과 마지막 날 리턴
    func getStartAndEndDateOfWeek(for date: Date) -> (Date, Date)? {
        let calendar = Calendar.current
        
        // 주의 시작 날짜 찾기
        var startDate = Date()
        var interval = TimeInterval(0)
        _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: date)
        
        // 주의 마지막 날짜 찾기
        let endDate = calendar.date(byAdding: .day, value: +6, to: startDate)!
        
        return (startDate, endDate)
    }
    
    
    
    @objc
    func prevButtonClicked() {
        let calendar = Calendar.current
        let startComponent = calendar.date(byAdding: .day, value: -7, to: currentPageDate)
        let endComponent = calendar.date(byAdding: .day, value: -7, to: endDate)
        
        currentPageDate = startComponent!
        endDate = endComponent!
        
        
        print(currentPageDate, endDate)
        
        fetchDataForPieChart()
        fetchDataForBarChart()
        
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .week)
        
        if musicTotalCnt == 0 && genreTotalCnt == 0 {
            barGraphView.isHidden = true
            pieGraphView.isHidden = true
        } else {
            barGraphView.isHidden = false
            pieGraphView.isHidden = false
            settingPieGraphView(dataPoints: genres, values: percentArr)
            settingBarGraphView()
            barGraphView.barChartView.setNeedsDisplay()
            pieGraphView.collectionView.reloadData()
            barGraphView.collectionView.reloadData()
        }
    }
    
    @objc
    func nextButtonClicked() {
        let calendar = Calendar.current
        let startComponent = calendar.date(byAdding: .day, value: +7, to: currentPageDate)
        let endComponent = calendar.date(byAdding: .day, value: +7, to: endDate)
        
        if startComponent! > Date() {    // 미래 날짜로는 넘어가지 못하게 한다
            return
        }
        
        currentPageDate = startComponent!
        endDate = endComponent!
        print(currentPageDate)
        
        fetchDataForPieChart()
        fetchDataForBarChart()
        
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .week)
        
        if musicTotalCnt == 0 && genreTotalCnt == 0 {
            barGraphView.isHidden = true
            pieGraphView.isHidden = true
        } else {
            barGraphView.isHidden = false
            pieGraphView.isHidden = false
            settingPieGraphView(dataPoints: genres, values: percentArr)
            settingBarGraphView()
            barGraphView.barChartView.setNeedsDisplay()
            pieGraphView.collectionView.reloadData()
            barGraphView.collectionView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let startDateString = currentPageDate.toString(of: .full)
        let endDateString = endDate.toString(of: .full)
        
        let tuple = repository.fetchWeekGenreDataForPieChart(startDate:startDateString, endDate: endDateString)
        
        if genres != Array(tuple.0) || counts != Array(tuple.1).map { Double($0) } {
            
            fetchDataForPieChart()
            fetchDataForBarChart()
            
            titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .week)
            
            if musicTotalCnt == 0 && genreTotalCnt == 0 {
                barGraphView.isHidden = true
                pieGraphView.isHidden = true
            } else {
                barGraphView.isHidden = false
                pieGraphView.isHidden = false
                settingPieGraphView(dataPoints: genres, values: percentArr)
                settingBarGraphView()
                barGraphView.barChartView.setNeedsDisplay()
                pieGraphView.collectionView.reloadData()
                barGraphView.collectionView.reloadData()
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        

        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        /* 데이터 로드 */
        initCurrentPageDate()
        fetchDataForPieChart()
        fetchDataForBarChart()
        
        
        /* titleView */
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .week)
        titleView.prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        titleView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        
        if musicTotalCnt == 0 && genreTotalCnt == 0 {
            barGraphView.isHidden = true
            pieGraphView.isHidden = true
        } else {
            barGraphView.isHidden = false
            pieGraphView.isHidden = false
            
            /* circle Graph */
            pieGraphView.titleLabel.text = "전체 장르 비율"
            
            settingPieGraphView(dataPoints: genres, values: percentArr)
            
            pieGraphView.collectionView.register(PieChartSideCollectionViewCell.self, forCellWithReuseIdentifier: PieChartSideCollectionViewCell.description())
            pieGraphView.collectionView.dataSource = self
            pieGraphView.collectionView.showsVerticalScrollIndicator = false

            
            /* bar Graph */
            barGraphView.titleLabel.text = "날짜별 장르 비율"
            
            settingBarGraphView()
            
            barGraphView.collectionView.register(BarChartSideCollectionViewCell.self, forCellWithReuseIdentifier: BarChartSideCollectionViewCell.description())
            barGraphView.collectionView.dataSource = self
            barGraphView.collectionView.showsHorizontalScrollIndicator = false
        }

    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleView)
        contentView.addSubview(pieGraphView)
        contentView.addSubview(barGraphView)
        
        barGraphView.backgroundColor = .white
        
        scrollView.showsVerticalScrollIndicator = false
        
    }
    override func setConstraints() {
        super.setConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(46)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
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
    
    
    func initCurrentPageDate() {
        guard let tuple = getStartAndEndDateOfWeek(for: currentPageDate) else { return }
        currentPageDate = tuple.0
        endDate = tuple.1
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
    
    func settingPieGraphView(dataPoints: [String], values: [Double]) {
        // dataPoints : genres, values: percentArr
        
        var pieChartDataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let pieDataEntry = PieChartDataEntry(
                value: values[i],   // 차트 비율을 위한 값
                label: percentArr[i] < 8 ? nil : "\(Int(percentArr[i])) %" // 실제로 나타나는 값
            )
            pieChartDataEntries.append(pieDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieChartDataEntries)
        pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.colors = colors.map{ UIColor(hexCode: $0) }
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieGraphView.pieChartView.data = pieChartData

        pieGraphView.pieChartView.legend.enabled = false
    }
    
    func fetchDataForBarChart() {
        let startDateString = currentPageDate.toString(of: .full)
        let endDateString = endDate.toString(of: .full)

        let data = repository.fetchWeekGenreDataForBarChart(startDate: startDateString, endDate: endDateString)
        
        barData = data.0
        musicTotalCnt = data.1
    }
    
    func settingBarGraphView() {
        
        let dateString = currentPageDate.toString(of: .full)
        
        
        // 값 전달(?)
        barGraphView.barChartView.dataList = barData
        barGraphView.barChartView.startDayString = dateString
        barGraphView.barChartView.dayCount = 7
        
        barGraphView.barChartView.genres = self.genres
        barGraphView.barChartView.colors = self.colors
    }
}




/* collectionView */
extension WeekChartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case pieGraphView.collectionView:
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


extension WeekChartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        print(scrollView.contentOffset.y)
//
//        if scrollView.contentOffset.y > 0 {
//            delegate?.setSmallTitle()
//        } else {
//            delegate?.setLargeTitle()
//        }
    }
}
