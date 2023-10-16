//
//  NotificationSettingViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit
import UserNotifications



class NotificationSettingViewController: BaseViewController {
    
    let repository = MusicItemTableRepository()
    
    let settingView = NotificationSettingListView()
    let timeView = NotificationTimeView()
    
    @objc
    func timeChanged(_ sender: UIDatePicker) {
        
        print("원하는 시간을 바꿨습니다. 새로운 알림을 등록합니다")
        let time = sender.date.toString(of: .hourMinute)
        UserDefaults.standard.set(time, forKey: NotificationUserDefaults.time.key)
        
        NotificationRepository.shared.updateNotifications()
        
        print("알림 추가가 끝나고, 오늘 데이터가 있는지 확인합니다")
        if repository.fetchDay(Date()) != nil {
            print("오늘은 이미 기록한 데이터가 있습니다. 알림을 삭제합니다")
            NotificationRepository.shared.delete(Date())
        } else {
            print("오늘 기록한 데이터가 없기 때문에, 따로 삭제하지 않습니다")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constant.Color.background
        
        navigationItem.largeTitleDisplayMode = .never
        
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
        
        
        // 시스템 알림이 꺼져있으면, 스위치를 off해준다
        NotificationRepository.shared.checkSystemSetting {
            
        } failureCompletionHandler: {
            DispatchQueue.main.async {
                self.settingView.controlSwitch.isOn = false
                self.timeView.isHidden = true
            }
        
        }

        
        
        timeView.timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
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
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
            
            DispatchQueue.main.async {
                if success {
                    print("권한이 허용되어 있습니다")
                    
                    if sender.isOn {
                        print("스위치가 켜집니다")
                        self.timeView.isHidden = false
                        
                        print("새로운 알림을 등록하는 updateNotification 함수 실행")
                        NotificationRepository.shared.updateNotifications()
                        UserDefaults.standard.set(true, forKey: NotificationUserDefaults.isAllowed.key)
                        
                        print("알림 추가가 끝나고, 오늘 데이터가 있는지 확인합니다")
                        if self.repository.fetchDay(Date()) != nil {
                            print("오늘은 이미 기록한 데이터가 있습니다. 알림을 삭제합니다")
                            NotificationRepository.shared.delete(Date())
                        } else {
                            print("오늘 기록한 데이터가 없기 때문에, 따로 삭제하지 않습니다")
                        }
                        
                    } else {
                        print("스위치가 꺼집니다")
                        self.timeView.isHidden = true
                        print("기존의 알림들을 모두 제거합니다. 새로운 알림은 추가되지 않습니다")
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UserDefaults.standard.set(false, forKey: NotificationUserDefaults.isAllowed.key)
                    }
                    
                    
                } else {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    print("권한이 허용되어 있지 않습니다. 시스템 설정으로 갈 수 있는 얼럿을 띄우겠습니다")
                    self.showAlert("시스템 알림 설정이 해제되어 있습니다", message: "원하는 시간에 알림을 받기 위해서 알림을 허용해주세요", okTitle: "설정으로 이동") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    sender.setOn(false, animated: true)
                    
                }
            }
            
            
        }
        
//        NotificationRepository.shared.checkSystemSetting {
//            DispatchQueue.main.async {
//                if sender.isOn {
//                    print("현재 메인쓰레드? : ", OperationQueue.current == OperationQueue.main)
//                    print("켜집니다아아아")
//                    self.timeView.isHidden = false
//
//                    // 새로운 알림 업데이트
//                    print("알림 설정 스위치를 작동했습니다. 새로운 알림을 등록할 예정입니다")
//                    NotificationRepository.shared.updateNotifications()
//
//                    UserDefaults.standard.set(true, forKey: NotificationUserDefaults.isAllowed.key)
//                } else {
//                    print("꺼집니다")
//                    self.timeView.isHidden = true
//
//                    // 기존 알림 모두 제거
//                    print("알림 설정 스위치를 해제했습니다. 기존의 알림들의 모두 제거됩니다")
//                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//
//                    UserDefaults.standard.set(false, forKey: NotificationUserDefaults.isAllowed.key)
//                }
//            }
//        } failureCompletionHandler: {
//            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//
//            DispatchQueue.main.async {
//                self.showAlert("시스템 알림 설정이 해제되어 있습니다", message: "원하는 시간에 알림을 받기 위해서 알림을 허용해주세요", okTitle: "설정으로 이동") {
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url)
//                    }
//                }
//
//                sender.setOn(false, animated: true)
//            }
//
//        }
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
