//
//  SaveView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/16.
//

import UIKit
import GoogleMobileAds

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
        view.text = String(localized: "음악 검색")
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    let searchBar = {
        let view = UISearchBar()
        view.isUserInteractionEnabled = false
        view.placeholder = String(localized: "오늘 들었던 음악을 검색하세요")
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

    let todayMusicLabel = {
        let view = UILabel()
        view.text = String(localized: "몇월 며칠의 음악 기록")
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createSaveLayout() )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(SaveCatalogCell.self, forCellWithReuseIdentifier: SaveCatalogCell.description())
        return view
    }()
    
    // 12/21. 구글 애드몹 배너 추가
    lazy var bannerView = {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        view.alpha = 1
        // test id : ca-app-pub-3940256099942544/2435281174
        // real id : ca-app-pub-8155830639201287/8054433650
        let isMyDevice = UserDefaults.standard.bool(forKey: "isMyDevice")   // 내 폰에서만 테스트 틀어지게 함.
        view.adUnitID = isMyDevice ? "ca-app-pub-3940256099942544/2435281174" : "ca-app-pub-8155830639201287/8054433650"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // 여기서 바로 로드해도 되는지는 모르겠지만... 되겠지 뭐
        view.load(GADRequest())
        view.delegate = self
        return view
    }()
    
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchMusicLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(fakeButton)
        contentView.addSubview(todayMusicLabel)
        contentView.addSubview(collectionView)
        
        // bannerView는 스크롤과 상관 없어야 함.
        // 스크롤뷰 위에 얹는 방식으로 구현
        self.addSubview(bannerView)
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
        
        // 몇월 며칠의 음악
        todayMusicLabel.snp.makeConstraints { make in
            make.top.equalTo(fakeButton.snp.bottom).offset(30)
            make.leading.equalTo(self).inset(18)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMusicLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(18)
            make.bottom.equalTo(contentView).inset(12)
        }
        
        // 배너뷰는 스크롤뷰 위에 올라가는 방식으로 구현
        bannerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
    }
    

}


// collectionView 레이아웃 함수
extension SaveView {
    private func createSaveLayout() -> UICollectionViewLayout {
       let layout = UICollectionViewFlowLayout()
       
       let width = UIScreen.main.bounds.width - 32
       
       layout.itemSize = CGSize(width: width, height: 120)
       layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
       
       return layout
   }
}

extension SaveView: GADBannerViewDelegate {
    /// 광고가 로드되었을 때 호출
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Ad received successfully.")
        }

        /// 광고 로드에 실패했을 때 호출
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Ad failed to load: \(error.localizedDescription)")
        }

        /// 광고가 클릭되었을 때 호출
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            print("Ad clicked.")
        }

        /// 광고가 화면에 표시되었을 때 호출
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("Ad will present screen.")
        }

        /// 광고 화면이 닫혔을 때 호출
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("Ad will dismiss screen.")
        }

        /// 광고 화면이 완전히 닫혔을 때 호출
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("Ad dismissed.")
        }
}
