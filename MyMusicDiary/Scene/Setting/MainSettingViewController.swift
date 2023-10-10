//
//  MainSettingViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit

class MainSettingViewController: BaseViewController {
    
    lazy var notificationSettingButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.addTarget(self, action: #selector(notificationSettingButtonClicked), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    print("Identifier: \(request.identifier)")
                    print("Title: \(request.content.title)")
                    print("Body: \(request.content.body)")
                    print("Trigger: \(String(describing: request.trigger))")
                    print("---")
                }
            }
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(notificationSettingButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        notificationSettingButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(300)
        }
    }
    
    @objc
    func notificationSettingButtonClicked() {
        print("hi")
        let vc = NotificationSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
