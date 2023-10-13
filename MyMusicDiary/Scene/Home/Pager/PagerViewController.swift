//
//  PagerViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView

import AVFoundation


// 데이터 받아오기 -> 맨 처음 (viewDidLoad)
// 이미 있는 음악을 그날 또 추가했을 때
// (일단 지금은)
    // 맨 앞에 나타나 있는 셀은 업데이트 x
    // 근데 스크롤하면서 뒤에 있는 셀 나오게 하면 그 때는 업데이트 o

class PagerViewController: BaseViewController {
    
    
    let player = AVPlayer()
    var playerItem: AVPlayerItem?
    
    
    var isPlaying = false   // cell에서도 쓰기 때문에 viewmodel로 굳이 옮기지 말자
    
    let pagerView = FSPagerView()

    let viewModel = PagerViewModel()
    
    @objc
    func settingButtonClicked() {
        let vc = MainSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let logoView = {
        let view = UIImageView()
        view.image = UIImage(named: "mainLogo")
        view.contentMode = .scaleAspectFit
//        view.backgroundColor = .black
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
        pagerView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
  
       
        navigationItem.titleView?.backgroundColor = .clear
        
//        navigationItem.title = "기록"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(settingButtonClicked))
        navigationItem.rightBarButtonItem = settingButton
        
        addObserverToPlayerStop()
        settingPagerView()
        viewModel.fetchData()   // dataList에 데이터 로드
        replacePlayer()     // previewURL을 업데이트하고, 미리 AVPlayerItem을 생성한다
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print(#function)
        
        isPlaying = false
        player.pause()
        player.seek(to: .zero)
        print("끝!!")
    }
    
    
    func addObserverToPlayerStop() {
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    func settingPagerView() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(MainPagerViewCell.self, forCellWithReuseIdentifier: MainPagerViewCell.description())
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        let bounds = UIScreen.main.bounds
        pagerView.itemSize = CGSize(
            width: bounds.width - 90,
            height: bounds.height - 300
        )
        
        pagerView.interitemSpacing = 20
    }
    
    func replacePlayer() {
        viewModel.updatePreviewURL(pagerView.currentIndex)  // 가운데 있는 셀의 url을 미리 받아둔다
        
        guard let url = viewModel.makeUrlByPreviewURL() else { return }
        
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(logoView)
        view.addSubview(pagerView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        
        
//        logoView.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
////            make.leading.equalTo(view).inset(18)
//            make.top.equalTo(view).inset(80)
//
//            make.height.equalTo(80)
//            make.width.equalTo(150)
//        }
        
        pagerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
            
        }
    }
}

extension PagerViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.numberOfItems()
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
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
        
        player.pause()
        isPlaying = false
        replacePlayer() // 미리 url 업데이트하고, PlayerItem도 미리 만들어둔다 (바로 재생할 준비)
    }
    

}



extension PagerViewController: PlayButtonActionProtocol {
    
    
    @objc
    func playerDidFinishPlaying() {
        isPlaying = false
//        player.pause()
        player.seek(to: .zero)
    }

    
    func play() {
        if !isPlaying {
            // 음악 정지 or 기본 상태일 때
            print("재생")
            player.play()
        } else {
            // 음악 재생 중일 때
            print("정지")
            player.pause()
        }
    }
    
    func showBottomSheet() {
        print("바텀시트 올리기")
        
        let vc = RecordDateViewController()
        
        vc.viewModel.item = viewModel.dataList[pagerView.currentIndex]    // 음악 정보를 넘겨준다
        
        vc.modalPresentationStyle = .pageSheet
        let nav = UINavigationController(rootViewController: vc)
        let sheet = nav.sheetPresentationController
        sheet?.detents = [.medium(), .large()]
        present(nav, animated: true)
    }
}


protocol PlayButtonActionProtocol: AnyObject {
    
    var isPlaying: Bool { get set }
    
    func play()
    
    func showBottomSheet()
}
