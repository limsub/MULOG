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
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(CustomPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.isInfinite = true  // 무한 스크롤
        
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        pagerView.backgroundView?.backgroundColor = .cyan   // 안먹음
        pagerView.itemSize = CGSize(width: 300, height: 500)
        
        
        
        
        view.addSubview(pagerView)
        
        
        
        view.addSubview(pageControl)
        
        
        pagerView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.horizontalEdges.equalTo(view)
            make.centerY.equalTo(view)
        }
    }
    
    override func setConfigure() {
        super.setConfigure()
        
    }
    override func setConstraints() {
        super.setConstraints()
    }
}

extension PagerViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 50
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! CustomPagerViewCell
        
        cell.imageView?.backgroundColor = [.red, .blue, .black].randomElement()!
        cell.imageView?.layer.shadowColor = UIColor.red.cgColor
        cell.imageView?.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        
        
        cell.imageView?.image = UIImage(named: ["sample1", "sample2", "sample3"].randomElement()!)
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.playImageView
        
        cell.parentVC = self
        
        cell.button2.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

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
