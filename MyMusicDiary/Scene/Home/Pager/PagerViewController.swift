//
//  PagerViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView

import AVFoundation


class PagerViewController: BaseViewController {
    
    let player = AVPlayer()
    var playerItem: AVPlayerItem?
    var currentURL: String = ""
    
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
        
        
        
        
        viewModel.cellForItemAt(index) { item in
            cell.previewURL = item.previewURL
            cell.designCell(item)
        }
        
        cell.parentVC = self
        
        
        cell.playButton.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)

        return cell
    }
    
    @objc
    func playButtonClicked(_ sender: UIButton) {
        print("HIHIHIHI")
 
        
        
        // 1. 음악 재생 or 멈춤
        
        
        // 2. 셀의 재생/멈춤 이미지 animate -> cell 파일 내에서 addTarget 하나 더 만들어서 처리
        
    }
}

extension PagerViewController: PlayButtonActionProtocol {
    func play(_ previewURL: String?, isPlaying: Bool) {
        
        
        guard let str = previewURL, let url = URL(string: str) else { return }
        
        
        if currentURL == str {
            // 같은 음악인 경우
            if isPlaying {
                // 재생중인 경우
                player.pause()
            } else {
                // 안재생중인 경우
                player.play()
            }
            
        } else {
            // 다른 음악인 경우 -> 바로 재생
            playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            currentURL = str
            
            player.play()
        }
        
    }
    
//    NotificationCenter.default
//        .addObserver(self,
//        selector: #selector(playerDidFinishPlaying),
//        name: .AVPlayerItemDidPlayToEndTime,
//        object: videoPlayer.currentItem
//    )
}

protocol PlayButtonActionProtocol: AnyObject {
    func play(_ previewURL: String?, isPlaying: Bool)
}
