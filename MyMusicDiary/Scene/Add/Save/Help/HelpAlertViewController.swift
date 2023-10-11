//
//  HelpAlertViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit

enum HelpType {
    case drag
    case representative
    case delete
}

class CustomAlertView: BaseView {
    
    var type: HelpType?
    
    let representLabel = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.backgroundColor = Constant.Color.main.withAlphaComponent(0.4)
        view.text = "대표"
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 40)
        view.textAlignment = .center
        return view
    }()
    
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
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 2
        
        view.backgroundColor = .red
        return view
    }()
    
    let subtitleLable = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.numberOfLines = 2
        view.backgroundColor = .red
        return view
    }()
    
    lazy var nextButton = {
        let view = UIButton()
        view.setTitle("확인", for: .normal)
        view.backgroundColor = .red
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
            make.top.equalTo(representLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(self).inset(18)
            make.height.equalTo(30)
        }
        subtitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(self).inset(8)
            make.height.equalTo(50)
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

class HelpAlertViewController: BaseViewController {
    
    var nextPageDelegate: NextPageProtocol?
    
    var type: HelpType?
    
    lazy var alertView = CustomAlertView(type: type!)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelected))
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(40)
            make.top.equalTo(view).inset(150)
            make.bottom.equalTo(view).inset(180)
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
