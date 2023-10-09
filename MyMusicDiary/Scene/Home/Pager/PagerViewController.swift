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
    var isPlaying = false
    
    var previewURL: String?
    
    var dataList: [Int] = [1, 2, 3, 4, 5, 6]
    
    let pagerView = FSPagerView()

    let viewModel = PagerViewModel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        
        
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
        
        previewURL = viewModel.currentPreviewURL(pagerView.currentIndex)
        replacePlayer()
        
        
    }
    
    func replacePlayer() {
        guard let str = previewURL, let url = URL(string: str) else { return }
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
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
        print("cellForItemAt : ", index)
        
        print("current Index : ", pagerView.currentIndex)
        
        
        
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: MainPagerViewCell.description(), at: index) as? MainPagerViewCell else { return FSPagerViewCell() }
        
        viewModel.cellForItemAt(index) { item in
            cell.designCell(item)
        }
        cell.parentVC = self
        
        return cell
    }
    
    // 선택 막기
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
    
    // 다음으로 넘김
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        print(#function)
        
        print("current Index : ", pagerView.currentIndex)
        
        previewURL = viewModel.currentPreviewURL(pagerView.currentIndex)
        replacePlayer()
        
        isPlaying = false
        currentURL = ""
        player.pause()
    }
    
    @objc
    func playerDidFinishPlaying() {
        
        isPlaying = false
        currentURL = ""
//        player.pause()
        player.seek(to: .zero)
        print("끝!!")
    }
}



extension PagerViewController: PlayButtonActionProtocol {
    func play() {
        
        guard let str = previewURL, let url = URL(string: str) else { return }
        
        if !isPlaying {
            // 음악 정지 or 기본 상태일 때
            if currentURL == str {
                // 같은 음악인 경우 -> 이어서 재생 (이미 생성된 item 사용)
            } else {
                // 다른 음악인 경우 -> item 새로 생성
                
                currentURL = str
            }
            print("재생")
            player.play()
        } else {
            // 음악 재생 중일 때
            
            print("정지")
            player.pause()
        }
    }
}

protocol PlayButtonActionProtocol: AnyObject {
    
    var isPlaying: Bool { get set }
    
    func play()
}
