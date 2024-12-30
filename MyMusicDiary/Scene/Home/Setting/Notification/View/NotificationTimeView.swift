//
//  NotificationTimeView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/14.
//

import UIKit

class NotificationTimeView: BaseView {
    let explainLabel = UILabel()
    let timePicker = UIDatePicker()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(explainLabel)
        addSubview(timePicker)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(12)
            
        }
        explainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(12)
            make.trailing.equalTo(timePicker.snp.leading).offset(-8)
        }
        
    }
    
    override func setting() {
        super.setting()
        
        explainLabel.numberOfLines = 0
        explainLabel.font = .systemFont(ofSize: 12)
        
        explainLabel.text = String(localized: "원하시는 시간을 선택해주세요. 그 날 음악이 기록되지 않은 경우, 알림을 보내드립니다")
        
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        
        timePicker.locale = Locale(identifier: String(localized: "ko")) 
    }
}
