//
//  PagerViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView




class PagerViewController: BaseViewController {
    
    
    let pagerView = FSPagerView()
    let pageControl = FSPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "하이하이"
        
        
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(CustomPagerViewCell.self, forCellWithReuseIdentifier: CustomPagerViewCell.description())
        pagerView.isInfinite = true  // 무한 스크롤
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width - 90, height: UIScreen.main.bounds.height - 300)
        print(UIScreen.main.bounds.width)
        pagerView.interitemSpacing = 20

        
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
        return 50
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CustomPagerViewCell.description(), at: index) as! CustomPagerViewCell
        
        cell.imageView?.backgroundColor = [.red, .blue, .black].randomElement()!
        cell.imageView?.layer.shadowColor = UIColor.red.cgColor
        cell.imageView?.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        
        
        cell.imageView?.image = UIImage(named: ["sample1", "sample2", "sample3"].randomElement()!)
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.playImageView
        
        cell.parentVC = self
        
        cell.playButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        return cell
    }
    
    @objc
    func buttonClicked(_ sender: UIButton) {
        print("HIHIHIHI")
 

        
        // 1. 음악 재생 or 멈춤
        
        
        // 2. 셀의 재생/멈춤 이미지 animate
    }
}

extension PagerViewController: PlayButtonDelegate {
    func playButtonClicked() {
        print("hi")
    }
}


protocol PlayButtonDelegate: AnyObject {
    func playButtonClicked()
}
