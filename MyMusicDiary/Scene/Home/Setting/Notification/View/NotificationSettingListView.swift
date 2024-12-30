//
//  NotificationSettingListView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/14.
//

import UIKit


class NotificationSettingListView: BaseView {
    
    let nameLabel = UILabel()
    let controlSwitch = UISwitch()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(nameLabel)
        addSubview(controlSwitch)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(12)
        }
        controlSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(12)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
        
        nameLabel.text = String(localized: "알림 허용")
        controlSwitch.isOn = false  // UserDefault
    }
}
