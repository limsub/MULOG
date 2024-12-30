//
//  HelpAlertView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/15.
//

import UIKit

class HelpAlertView: BaseView {
    
    var type: HelpType?
    
    // case 2 - 대표 레이블
    let representLabel = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.backgroundColor = Constant.Color.main2.withAlphaComponent(0.3)
        view.text = String(localized: "대표")
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 40)
        view.textAlignment = .center
        return view
    }()
    
    // case 1, 3 - 이미지뷰x2
    let firstImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    let secondImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 공통
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.textAlignment = .center
        view.numberOfLines = 0
        
//        view.backgroundColor = .red
        return view
    }()
    
    let subtitleLable = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
//        view.backgroundColor = .red
        return view
    }()
    
    lazy var nextButton = {
        let view = UIButton()
        view.setTitle(String(localized: "확인"), for: .normal)
//        view.backgroundColor = .red
        view.backgroundColor = Constant.Color.main2
        view.layer.cornerRadius = 20
        
        return view
    }()
    

    
    convenience init(type: HelpType?) {
        self.init()
        
        self.backgroundColor = .white
        self.type = type
    }
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(representLabel)
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(titleLabel)
        addSubview(subtitleLable)
        addSubview(nextButton)
    }
    override func setConstraints() {
        super.setConstraints()
        
        representLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(60)
            make.horizontalEdges.equalTo(self).inset(60)
            make.height.equalTo(70)
        }
        firstImageView.snp.makeConstraints { make in
            make.top.equalTo(self).inset(60)
            make.leading.equalTo(self).inset(30)
            make.height.equalTo(70)
            make.trailing.equalTo(self.snp.centerX)
        }
        secondImageView.snp.makeConstraints { make in
            make.top.equalTo(self).inset(60)
            make.trailing.equalTo(self).inset(30)
            make.height.equalTo(70)
            make.leading.equalTo(self.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(representLabel.snp.bottom).offset(70)
            make.horizontalEdges.equalTo(self).inset(18)
//            make.height.equalTo(30)
        }
        subtitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self).inset(8)
//            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(40)
            make.horizontalEdges.equalTo(self).inset(60)
            make.height.equalTo(50)
        }
        
    }
    override func setting() {
        super.setting()
        
        
    }
}


