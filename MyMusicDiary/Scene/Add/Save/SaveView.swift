//
//  SaveView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/16.
//

import UIKit

class SaveView: BaseView {
    
    // 10/11 UI 수정
    let scrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchMusicLabel = {
        let view = UILabel()
        view.text = "음악 검색"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    let searchBar = {
        let view = UISearchBar()
        view.isUserInteractionEnabled = false
        view.placeholder = "오늘 들었던 음악을 검색하세요"
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = .clear
        return view
    }()
    lazy var fakeButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    let genreChartLabel = {
        let view = UILabel()
        view.text = "장르별 음악"
        view.font = .boldSystemFont(ofSize: 18)
        
//        view.backgroundColor = .blue
        return view
    }()
    lazy var genreCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createGenreSaveLayout() )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false

        view.register(GenreCatalogCell.self, forCellWithReuseIdentifier: GenreCatalogCell.description())
        
        
//        view.backgroundColor = .black
        return view
    }()
    
    let todayMusicLabel = {
        let view = UILabel()
        view.text = "몇월 며칠의 음악 기록"
        view.font = .boldSystemFont(ofSize: 18)
        
//        view.backgroundColor = .blue
        return view
    }()
    lazy var helpButton = {
        let view = UIButton()
        view.imageEdgeInsets = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
        view.setImage(UIImage(named: "question"), for: .normal)
        return view
    }()
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createSaveLayout() )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(SaveCatalogCell.self, forCellWithReuseIdentifier: SaveCatalogCell.description())
        
//        view.backgroundColor = .black
        return view
    }()
    
    
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchMusicLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(fakeButton)
        contentView.addSubview(genreChartLabel)
        contentView.addSubview(genreCollectionView)
        contentView.addSubview(todayMusicLabel)
        contentView.addSubview(helpButton)
        contentView.addSubview(collectionView)
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        // 스크롤 뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        // 음악 검색
        searchMusicLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchMusicLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.height.equalTo(40)
        }
        fakeButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBar)
            make.horizontalEdges.equalTo(contentView)
        }
        
        // 장르별 음악
        genreChartLabel.snp.makeConstraints { make in
            make.top.equalTo(fakeButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genreChartLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        // 몇월 며칠의 음악
        todayMusicLabel.snp.makeConstraints { make in
            make.top.equalTo(genreCollectionView.snp.bottom).offset(30)
            make.leading.equalTo(self).inset(18)
        }
        helpButton.snp.makeConstraints { make in
            make.leading.equalTo(todayMusicLabel.snp.trailing).offset(-8)
            make.height.equalTo(65)
            make.width.equalTo(65)
            make.centerY.equalTo(todayMusicLabel)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMusicLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(18)
            make.bottom.equalTo(contentView).inset(12)
        }
        
        
    }
    

}


// collectionView 레이아웃 함수
extension SaveView {
    
    func createSaveLayout() -> UICollectionViewLayout {
       let layout = UICollectionViewFlowLayout()
       
       let width = UIScreen.main.bounds.width - 32
       
       layout.itemSize = CGSize(width: width, height: 120)
       layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
       
       return layout
   }
    
    func createGenreSaveLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        return layout
    }
    
}
