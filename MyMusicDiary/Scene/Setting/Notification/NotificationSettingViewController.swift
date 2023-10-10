//
//  NotificationSettingViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit
import UserNotifications

class NotificationUpdate {
    
    static let shared = NotificationUpdate()
    
    let content = UNMutableNotificationContent()
    
    func updateNotifications() {
        
        // content 세팅
        content.title = "오늘의 음악을 기록해주세요!"
        content.body = "아직 오늘 음악을 기록하지 않았습니다"
        
        // UserDefault에 저장된 값을 가져온다
        let time = UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key)!
        
        guard let hour = Int(time.substring(from: 0, to: 1)) else { return }
        guard let minute =  Int(time.substring(from: 2, to: 3)) else { return }
        
        
        // 기존 request 제거
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // 새로운 request 등록
        for i in 0...59 {
            guard let notiDay = Calendar.current.date(byAdding: .day, value: i, to: Date()) else { continue }
            let notiDayComponent = Calendar.current.dateComponents([.day, .month, .year], from: notiDay)
            
            var component = DateComponents()
            component.hour = hour
            component.minute = minute
            component.year = notiDayComponent.year
            component.month = notiDayComponent.month
            component.day = notiDayComponent.day
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: component,
                repeats: false
            )
            
            let identifier = notiDay.toString(of: .full)
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
//                print(error)
            }
            
        }
        
    }
}


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
        
        nameLabel.text = "알림 허용"
        controlSwitch.isOn = false  // UserDefault
    }
}


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
        
//        backgroundColor = .white
        
        explainLabel.numberOfLines = 0
        explainLabel.font = .systemFont(ofSize: 12)
        
        explainLabel.text = "원하시는 시간을 선택해주세요. 그 날 음악이 기록되지 않은 경우, 알림을 보내드립니다"
        
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        
        timePicker.locale = Locale(identifier: "ko") // 다국어 대응
    }
}


class NotificationSettingViewController: BaseViewController {
    
    let settingView = NotificationSettingListView()
    let timeView = NotificationTimeView()
    
    

    

    
    @objc
    func timeChanged(_ sender: UIDatePicker) {
        
        let time = sender.date.toString(of: .hourMinute)
        UserDefaults.standard.set(time, forKey: NotificationUserDefaults.time.key)
        
        NotificationUpdate.shared.updateNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SceneDelegate에서 넣어주기 때문에 없을 리가 없지만, 혹시 모르니까
        if UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key) == nil {
            UserDefaults.standard.set("2100", forKey: NotificationUserDefaults.time.key)
        }
        
        // UserDefaults에 저장된 시간을 가져와서, datePicker의 초기값으로 넣어준다
        let time = UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key)!
        
        guard let initialTime = time.toDate(to: .hourMinute) else { return }
        

        timeView.timePicker.setDate(initialTime, animated: true)
        
        
        
        // UserDefaults에 저장된 값을 통해, 스위치 on/off를 결정한다
        let isSwitchOn = UserDefaults.standard.bool(forKey: NotificationUserDefaults.isAllowed.key)
        settingView.controlSwitch.isOn = isSwitchOn
        timeView.isHidden = !isSwitchOn
        
        
        
        timeView.timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
    
 
        // userdefault 확인해서 스위치 켜주거나 꺼주거나
        
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        
        settingView.layer.cornerRadius = 10
        settingView.controlSwitch.addTarget(self, action: #selector(switchClicked), for: .valueChanged)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(settingView)
        view.addSubview(timeView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        settingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view).inset(18)
            make.height.equalTo(44)
        }
        timeView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view).inset(18)
            make.height.equalTo(40)
        }
    }
    
    @objc
    func switchClicked(_ sender: UISwitch) {
        
        

        if sender.isOn {
            print("켜집니다아아아")
            timeView.isHidden = false
            
            // 새로운 알림 업데이트
            NotificationUpdate.shared.updateNotifications()
            
            UserDefaults.standard.set(true, forKey: NotificationUserDefaults.isAllowed.key)
        } else {
            print("꺼집니다")
            timeView.isHidden = true
            
            // 기존 알림 모두 제거
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            UserDefaults.standard.set(false, forKey: NotificationUserDefaults.isAllowed.key)
            
        }
        
        print("hi")
    }
    
}


enum NotificationUserDefaults {
    case isAllowed
    case time
    
    var key: String {
        switch self {
        case .isAllowed:
            return "notificationAllowed"
        case .time:
            return "notificationTime"
        }
    }
}
