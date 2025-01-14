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
    
    var parentVC: PlayButtonActionProtocol?
    
    // 1. 앨범 커버 이미지 -> 기본 imageView 사용
    // 2. 제목 레이블
    let titleLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 26)
//        view.adjustsFontSizeToFitWidth = true
        view.text = "좋은 날"
        return view
    }()
    // 3. 아티스트 레이블
    let artistLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .lightGray
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
        
        view.tintColor = .white
        view.alpha = 0
    
        return view
    }()
    // 6. 기록 날짜 레이블
    let recordLabel = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        view.font = .boldSystemFont(ofSize: 20)
        view.backgroundColor = .black
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 2
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.text = "6번 기록한 음악입니다"
    
        return view
    }()
    // 7. 기록 날짜 레이블 위의 버튼 (투명)
    lazy var recordButton = {
        let view = UIButton()
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
        
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "락"
        return view
    }()
    let genre2Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "발라드"
        return view
    }()
    let genre3Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "K-POP"
        return view
    }()
    
    // 9. 음악 재생 설명 레이블
    let explainPlayLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11)
        view.textColor = .lightGray
        view.text = String(localized: "앨범 커버를 터치하면 Apple Music API에서\n 제공하는 preview 음원이 재생됩니다")
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    
    
    

    @objc
    func playButtonClicked() {
        // 이미지 관련 로직
        // 1. 뿅 나오게
        // 2. 2초 걸리면서 점점 흐려짐
        
        // parentVC.isPlaying을 사용하면 어떨까
        
        
        
        
        if parentVC == nil { return }
        
        
        if !NetworkMonitor.shared.isConnected {
            guard let vc = parentVC as? UIViewController else { return }
            vc.showSingleAlert(String(localized: "네트워크 연결 상태가 좋지 않습니다"),
                               message: String(localized: "연결 상태를 확인해주세요")
            )
            return
        }
                
        print("현재 상태 : \(parentVC?.isPlaying)")
        
        parentVC?.play()

        self.playImageView.image = UIImage(systemName: (parentVC?.isPlaying ?? false) ? "play.circle" : "pause.circle")/*?.tintedWithLinearGradientColors(colorsArr: [Constant.Color.main2.cgColor, Constant.Color.main3.cgColor, Constant.Color.main4.cgColor])*/
        
        self.playImageView.alpha = 1
        UIView.animate(withDuration: 1.5) {
            self.playImageView.alpha = 0
        } completion: { _ in
            print("finish")
        }

        parentVC?.isPlaying.toggle()
    }
    
    @objc
    func recordButtonClicked() {
        parentVC?.showBottomSheet()
    }
    
    
    override func prepareForReuse() {
        
        self.imageView?.contentMode = .scaleAspectFit
        
        
        self.imageView!.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(imageView!.snp.width)
        }

    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)

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
        
        addSubview(explainPlayLabel)

        // 얘는 뭔지 잘 모르겠네
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        if self.imageView == nil { return }
        
        self.imageView!.snp.makeConstraints { make in
            make.top.equalTo(self).inset(14)
            make.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(imageView!.snp.width)
        }
        
        
        playImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.imageView!).inset(80)
        }
        
        playButton.snp.makeConstraints { make in
            make.edges.equalTo(self.imageView!)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(12)
            make.top.equalTo(self.imageView!.snp.bottom).offset(18)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self)
//            make.horizontalEdges.equalTo(self).inset(12)
            make.height.equalTo(25)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(stackView.snp.bottom).offset(30)
        }
        recordButton.snp.makeConstraints { make in
            make.edges.equalTo(recordLabel)
        }
        
        
        explainPlayLabel.snp.makeConstraints { make in
            make.top.equalTo(recordButton.snp.bottom).offset(4)
            make.centerX.equalTo(contentView)
//            make.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func designCell(_ sender: MusicItemTable) {

        if let str = sender.bigImageURL, let url = URL(string: str) {
            // * 다운샘플링 필요
            self.imageView?.kf.setImage(with: url)
        }
        
        titleLabel.text = sender.name
        artistLabel.text = sender.artist
        
        recordLabel.text = (sender.count > 1) ? "\(sender.count) records" : "\(sender.count) record"
        
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
