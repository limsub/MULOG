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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelected))
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(40)
            make.top.equalTo(view).inset(150)
            make.height.equalTo(view).multipliedBy(0.65)
        }
        
        alertView.layer.cornerRadius = 20
        
        alertView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        switch type {
        case .drag:
            alertView.representLabel.isHidden = true
            alertView.firstImageView.image = UIImage(named: "up_down")
            alertView.secondImageView.image = UIImage(named: "drag_finger")
            
            alertView.titleLabel.text = "원하는 순서대로 곡을 배치해주세요"
            alertView.subtitleLable.text = "셀을 꾹 눌러서 순서를 바꿀 수 있어요"
            
            
        case .representative:
            alertView.firstImageView.isHidden = true
            alertView.secondImageView.isHidden = true
            
            alertView.titleLabel.text = "대표 음악을 선택해주세요"
            alertView.subtitleLable.text = "맨 위에 있는 음악이 대표 음악이 됩니다. 대표 음악은 캘린더에서 바로 확인할 수 있어요"
            
            
        case .delete:
            alertView.representLabel.isHidden = true
            alertView.firstImageView.image = UIImage(named: "delete")
            alertView.secondImageView.image = UIImage(named: "press_finger")
            
            alertView.titleLabel.text = "잘못 선택한 곡은 지워주세요"
            alertView.subtitleLable.text = "셀을 한 번 터치하면 곡이 지워져요"
            
            
        default:
            break;
        }
    }
    
    @objc
    func didSelected() {
        nextPageDelegate?.dismiss()
    }
    
    @objc
    func nextButtonClicked() {
        nextPageDelegate?.goNext(type!)
    }
    
}
