//
//  HelpAlertViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit



class HelpAlertViewController: BaseViewController {
    

    var nextPageDelegate: NextPageProtocol?
    
    var type: HelpType?
    
    lazy var alertView = HelpAlertView(type: type!)
    
    lazy var neverSeeButton = {
        let view = UIButton()
        view.setTitle(String(localized: "다시 보지 않기"), for: .normal)
        view.setTitleColor(.lightGray, for: .normal)
        view.addTarget(self, action: #selector(neverSeeButtonClicked), for: .touchUpInside)
        return view
    }()
    let lineView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 20
        alertView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(alertView)
        view.addSubview(neverSeeButton)
        view.addSubview(lineView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        alertView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(40)
            make.top.equalTo(view).inset(150)
            make.height.equalTo(view).multipliedBy(0.65)
        }
        neverSeeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(alertView.snp.bottom).offset(4)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(neverSeeButton.snp.bottom).offset(0)
            make.centerX.equalTo(view)
            make.width.equalTo(neverSeeButton)
            make.height.equalTo(1)
        }
    }
    override func setting() {
        super.setting()
        
        switch type {
        case .drag:
            alertView.representLabel.isHidden = true
            alertView.firstImageView.image = UIImage(named: "up_down")
            alertView.secondImageView.image = UIImage(named: "saveView_scrollHand")
            
            alertView.titleLabel.text = String(localized: "원하는 순서대로 곡을 배치해주세요")
            alertView.subtitleLable.text = String(localized: "셀을 꾹 눌러서 순서를 바꿀 수 있어요")
            
            
        case .representative:
            alertView.firstImageView.isHidden = true
            alertView.secondImageView.isHidden = true
            
            alertView.titleLabel.text = String(localized: "대표 음악을 선택해주세요")
            alertView.subtitleLable.text = String(localized: "맨 위에 있는 음악이 대표 음악이 됩니다. 대표 음악은 캘린더에서 바로 확인할 수 있어요")
            
            
        case .delete:
            alertView.representLabel.isHidden = true
            alertView.firstImageView.image = UIImage(named: "delete")
            alertView.secondImageView.image = UIImage(named: "press_finger")
            
            alertView.titleLabel.text = String(localized: "잘못 선택한 곡은 지워주세요")
            alertView.subtitleLable.text = String(localized: "셀을 한 번 터치하면 곡이 지워져요")
            
            
        default:
            break;
        }
    }

    
    @objc
    func nextButtonClicked() {
        nextPageDelegate?.goNext(type!)
    }
    
    @objc
    func neverSeeButtonClicked() {
        UserDefaults.standard.set(true, forKey: helpView.showHelpView.rawValue)
        nextPageDelegate?.dismiss()
    }
    
}
