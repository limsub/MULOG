//
//  CumstomPagerViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import UIKit
import FSPagerView
import Kingfisher



class MainPagerViewCell: FSPagerViewCell {
    
    var previewURL: String?

    var parentVC: PlayButtonActionProtocol?
    
    var isPlaying = false   // 현재 재생 여부를 일단 여기에 저장
    
    // 1. 앨범 커버 이미지 -> 기본 imageView 사용
    // 2. 제목 레이블
    let titleLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "좋은 날"
        return view
    }()
    // 3. 아티스트 레이블
    let artistLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "아이유"
        return view
    }()
    // 4. 앨범 커버 위의 버튼 (투명)
    lazy var playButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.addTarget(self.parentVC, action: #selector(playButtonClicked), for: .touchUpInside)
        return view
    }()
    // 5. 재생 / 정지 이미지
    let playImageView = {
        let view = UIImageView()
        view.tintColor = .lightGray
        view.alpha = 0  // 안보이게
        return view
    }()
    // 6. 기록 날짜 레이블
    let recordLabel = {
        let view = UILabel()
        view.text = "6번 기록한 음악입니다"
        return view
    }()
    // 7. 기록 날짜 레이블 위의 버튼 (투명)
    lazy var recordButton = {
        let view = UIButton()
        view.backgroundColor = .blue.withAlphaComponent(0.1)
        view.addTarget(self.parentVC, action: #selector(recordButtonClicked), for: .touchUpInside)
        return view
    }()
    // 8. 장르 레이블 in 스택뷰
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    // 8. 장르 레이블
    let genre1Label = {
        
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "락"
        return view
    }()
    let genre2Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "발라드"
        return view
    }()
    let genre3Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "K-POP"
        return view
    }()

    @objc
    func playButtonClicked() {
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

        parentVC?.play(previewURL, isPlaying: isPlaying)
        
        isPlaying.toggle()
    }
    
    @objc
    func recordButtonClicked() {
        print(#function)
    }
    
    
    override func prepareForReuse() {
        
        self.imageView?.contentMode = .scaleAspectFit
        
        isPlaying = false
        
        self.imageView!.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(imageView!.snp.width)
        }

    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray.withAlphaComponent(0.1)
        
        self.imageView!.clipsToBounds = true
        self.imageView!.layer.cornerRadius = 10
        
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(playImageView)
        addSubview(playButton)      // 버튼을 제일 위에 (어차피 투명함)
        addSubview(recordLabel)
        addSubview(recordButton)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(genre1Label)
        stackView.addArrangedSubview(genre2Label)
        stackView.addArrangedSubview(genre3Label)

        // 얘는 뭔지 잘 모르겠네
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        if self.imageView == nil { return }
        
        self.imageView!.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(imageView!.snp.width)
        }
        
        
        playImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.imageView!).inset(80)
        }
        
        playButton.snp.makeConstraints { make in
            make.edges.equalTo(self.imageView!)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.imageView!.snp.bottom).offset(18)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom)
            make.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(40)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(stackView.snp.bottom).offset(30)
        }
        recordButton.snp.makeConstraints { make in
            make.edges.equalTo(recordLabel)
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
    
    func designCell(_ sender: MusicItemTable) {

        if let str = sender.bigImageURL, let url = URL(string: str) {
            self.imageView?.kf.setImage(with: url)
        }
        
        titleLabel.text = sender.name
        artistLabel.text = sender.artist
        recordLabel.text = "\(sender.count)번 기록한 음악입니다"
        
        // "음악" 제외
        for (index, item) in [genre1Label, genre2Label, genre3Label].enumerated() {
            item.isHidden = false
            
            var genreIdx = index
            if index >= 1 {
                genreIdx = index + 1
            }
            
            if genreIdx <= sender.genres.count - 1 {
                item.text = sender.genres[genreIdx]
            } else {
                item.isHidden = true
            }
        }

    }
}
