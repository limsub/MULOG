//
//  CumstomPagerViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView



class CustomPagerViewCell: FSPagerViewCell {
    
    var parentVC: PagerViewController?  // 버튼에 대한 액션 target 연결용
    
    var isPlaying = false   // 현재 재생 여부를 일단 여기에 저장
    
    // 1. 앨범 커버 이미지 -> 기본 imageView 사용
    // 2. 제목 레이블
    let titleLabel = {
        let view = UILabel()
        return view
    }()
    // 3. 아티스트 레이블
    let artistLabel = {
        let view = UILabel()
        return view
    }()
    
    // 두 개의 UIButton을 추가
    let button1: UIButton = {
        let button = UIButton()
        button.setTitle("Button 1", for: .normal)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton()
        button.setTitle("Button 2", for: .normal)
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self.parentVC, action: #selector(clicked), for: .touchUpInside)
        return button
    }()
    
    @objc
    func clicked() {
        // 이미지 관련 로직
        // 1. 뿅 나오게
        // 2. 2초 걸리면서 점점 흐려짐

        self.playImageView.image = UIImage(systemName: isPlaying ? "play.circle" : "pause.circle")
        self.playImageView.alpha = 1
        UIView.animate(withDuration: 1.5) {
            self.playImageView.alpha = 0
        } completion: { _ in
            print("finish")
        }
        
        isPlaying.toggle()
    }
    
    let playImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "play.circle")
        view.alpha = 0
        
        return view
    }()
    
    
    
    override func prepareForReuse() {
//        super.prepareForReuse()
        
        
        self.imageView!.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.height.equalTo(imageView!.snp.width)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        
        // UIButton을 셀에 추가
        addSubview(button1)
        
        addSubview(playImageView)
        
        addSubview(button2) // 얜 어차피 투명으로 할거라 맨 위에 있어도 상관없음
        
        
        // UIButton 레이아웃 설정
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        button1.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalTo(self)
        }
        
        self.imageView!.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.height.equalTo(imageView!.snp.width)
        }
        
        button2.snp.makeConstraints { make in
            make.edges.equalTo(imageView!).inset(20)
        }
        
        playImageView.snp.makeConstraints { make in
            make.edges.equalTo(button2).inset(30)
        }
        
        
//        NSLayoutConstraint.activate([
//            button1.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            button1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            button1.widthAnchor.constraint(equalToConstant: 100),
//            button1.heightAnchor.constraint(equalToConstant: 40),
//
//            button2.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            button2.leadingAnchor.constraint(equalTo: button1.trailingAnchor, constant: 20),
//            button2.widthAnchor.constraint(equalToConstant: 100),
//            button2.heightAnchor.constraint(equalToConstant: 40),
//        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
