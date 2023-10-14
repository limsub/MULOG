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
    
    var delegate: LargeTitleDelegate?
    
    
    // pie chart랑 bar chart랑 다른 데이터 사용함 (애초에 repository 가져올 때부터)
    // 단, 장르랄 색상은 맞춰주기 위해, bar chart에서 genres, colors 배열 접근해서 해당 장르가 어떤 색상인지는 확인하기
    
    

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
    
    
    
    @objc
    func prevButtonClicked() {
        let calendar = Calendar.current
        let component = calendar.date(byAdding: .month, value: -1, to: currentPageDate)
        
        currentPageDate = component!
        print(currentPageDate)
        
        fetchDataForPieChart(currentPageDate)
        fetchDataForBarChart()
        
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .month)
        settingPieGraphView(dataPoints: genres, values: percentArr)
        settingBarGraphView()
        barGraphView.barChartView.setNeedsDisplay()
        pieGraphView.collectionView.reloadData()
        barGraphView.collectionView.reloadData()
    }
    
    @objc
    func nextButtonClicked() {
        let calendar = Calendar.current
        let component = calendar.date(byAdding: .month, value: +1, to: currentPageDate)
        
        currentPageDate = component!
        print(currentPageDate)
        
        fetchDataForPieChart(currentPageDate)
        fetchDataForBarChart()
        
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .month)
        settingPieGraphView(dataPoints: genres, values: percentArr)
        settingBarGraphView()
        barGraphView.barChartView.setNeedsDisplay()
        pieGraphView.collectionView.reloadData()
        barGraphView.collectionView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        
        /* 데이터 로드 */
        initCurrentPageDate()
        fetchDataForPieChart(currentPageDate)
        fetchDataForBarChart()
        
        
        /* titleView */
        titleView.setView(startDay: currentPageDate, musicCnt: musicTotalCnt, genreCnt: genreTotalCnt, type: .month)
        titleView.prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        titleView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        

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
            make.top.equalTo(contentView).inset(8) // tabman의 bar를 custom으로 잡았다
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.height.equalTo(130)
        }
        pieGraphView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.height.equalTo(300)
        }
        barGraphView.snp.makeConstraints { make in
            make.top.equalTo(pieGraphView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.height.equalTo(400)
            make.bottom.equalTo(contentView).inset(12)
        }
    }
    
    
    func initCurrentPageDate() {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month], from: currentPageDate)
        component.day = 2
        currentPageDate = calendar.date(from: component) ?? Date()
    }
    
    func fetchDataForPieChart(_ date: Date) {
        
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
        genreTotalCnt = Int(sum)

        let tmpColors = UIColor.GenreColor.allCases.shuffled()
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
        let dateString = currentPageDate.toString(of: .yearMonth)

        let data = repository.fetchMonthGenreDataForBarChart(dateString)
        
        barData = data.0
        musicTotalCnt = data.1
    }
    
    func settingBarGraphView() {
        
        let dateString = currentPageDate.toString(of: .full)
        
        // 값 전달(?)
        barGraphView.barChartView.dataList = barData
        barGraphView.barChartView.startDayString = dateString
        barGraphView.barChartView.dayCount = calculateDayCnt(dateString)
        
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
}




/* collectionView */
extension MonthChartViewController: UICollectionViewDataSource {
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

extension MonthChartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y > 0 {
            delegate?.setSmallTitle()
        } else {
            delegate?.setLargeTitle()
        }
    }
}
