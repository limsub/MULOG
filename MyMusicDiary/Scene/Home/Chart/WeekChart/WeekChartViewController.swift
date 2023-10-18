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

    let weekChartView = WeekChartView()
    let viewModel = WeekChartViewModel()
    
    
    override func loadView() {
        self.view = weekChartView
    }
    
    func updateViews() {
        viewModel.fetchDataForPieChart()
        viewModel.fetchDataForBarChart()
        
        weekChartView.titleView.setView(
            startDay: viewModel.currentPageDate,
            musicCnt: viewModel.musicTotalCnt,
            genreCnt: viewModel.genreTotalCnt,
            type: .week
        )
        
        if viewModel.isZeroData() {
            weekChartView.setHiddenView(true)
        } else {
            weekChartView.setHiddenView(false)
            
            weekChartView.updatePieGraphView(
                dataPoints: viewModel.genres,
                values: viewModel.percentArr,
                colors: viewModel.colors
            )
            weekChartView.updateBarGraphView(
                currentPageDate: viewModel.currentPageDate,
                barData: viewModel.barData,
                genres: viewModel.genres,
                colors: viewModel.colors
            )
            
            weekChartView.reloadViews()
        }
    }
    
    @objc
    func prevButtonClicked() {
        if viewModel.changeCurrentPageDateEndDateByScroll(-7) {
            updateViews()
        }
    }
    
    @objc
    func nextButtonClicked() {
        if viewModel.changeCurrentPageDateEndDateByScroll(+7) {
            updateViews()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.isDataChanged() {
            print("값이 바뀌었다!!")
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        /* 데이터 로드 */
        viewModel.initCurrentPageDateEndDate()
        
        updateViews()
        
        weekChartView.titleView.prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        weekChartView.titleView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        weekChartView.pieGraphView.collectionView.dataSource = self
        weekChartView.barGraphView.collectionView.dataSource = self
    }
}




/* collectionView */
extension WeekChartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genreNum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case weekChartView.pieGraphView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieChartSideCollectionViewCell.description(), for: indexPath) as? PieChartSideCollectionViewCell else { return UICollectionViewCell() }
             
            cell.colorImageView.backgroundColor = viewModel.colorImageView(indexPath)
            cell.nameLabel.text = viewModel.nameLabel(indexPath)
            cell.countLabel.text = viewModel.countLabel(indexPath)
            cell.percentLabel.text = viewModel.percentLabel(indexPath)
            
            return cell
            
        case weekChartView.barGraphView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarChartSideCollectionViewCell.description(), for: indexPath) as? BarChartSideCollectionViewCell else { return UICollectionViewCell() }
            
            cell.colorImageView.backgroundColor = viewModel.colorImageView(indexPath)
            cell.nameLabel.text = viewModel.nameLabel(indexPath)
            
            return cell
         
        default:
            return UICollectionViewCell()
        }

        
    }
}
