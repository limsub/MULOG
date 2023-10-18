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
        
    }
    
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
