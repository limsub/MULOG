//
//  PagerViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView




class PagerViewController: BaseViewController {
    
    var dataList: [Int] = [1, 2, 3, 4, 5, 6]
    
    let pagerView = FSPagerView()

    let viewModel = PagerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "하이하이"
        
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(MainPagerViewCell.self, forCellWithReuseIdentifier: MainPagerViewCell.description())
        pagerView.isInfinite = true  // 무한 스크롤
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width - 90, height: UIScreen.main.bounds.height - 300)
        print(UIScreen.main.bounds.width)
        pagerView.interitemSpacing = 20

        
        viewModel.fetchData()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(pagerView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        pagerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension PagerViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.numberOfItems()
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        print(index)
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: MainPagerViewCell.description(), at: index) as! MainPagerViewCell
        
        cell.parentVC = self
        
        
        viewModel.cellForItemAt(index) { item in
            cell.designCell(item)
        }
        
        
        
        cell.playButton.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)

        return cell
    }
    
    @objc
    func playButtonClicked(_ sender: UIButton) {
        print("HIHIHIHI")
 
        
        
        // 1. 음악 재생 or 멈춤
        
        
        // 2. 셀의 재생/멈춤 이미지 animate
    }
}
