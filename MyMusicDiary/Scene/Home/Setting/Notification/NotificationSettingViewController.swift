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
        print("(realm 대비) 현재 메인쓰레드? : ", OperationQueue.current == OperationQueue.main)
        if repository.fetchDay(Date()) != nil {
            print("오늘은 이미 기록한 데이터가 있습니다. 알림을 삭제합니다")
            NotificationRepository.shared.delete(Date())
        } else {
            print("오늘 기록한 데이터가 없기 때문에, 따로 삭제하지 않습니다")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 혹시나 백그라운드에서 변화가 있었을 때, 씬딜리게이트에서 값을 바꿔줄 예정
        SystemNotification.shared.isOn.bind { value in
            DispatchQueue.main.async {
                if value {
                    // 시스템에서 혀용했을 때는 다시 돌아오면 직접 허용시키게 하지만
                } else {
                    // 시스템에서 거절했을 때는 아예 여기서도 거절을 시켜줘야 한다
                    self.settingView.controlSwitch.isOn = false
                    self.timeView.isHidden = true
                }
            }
        }
        

        NotificationRepository.shared.checkSystemSetting {
            SystemNotification.shared.isOn.value = true
        } failureCompletionHandler: {
            SystemNotification.shared.isOn.value = false
        }
        
        
        
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
        print("유저디폴츠에 저장되있는 알림 허용 여부 값 : ", isSwitchOn)
        settingView.controlSwitch.isOn = isSwitchOn
        timeView.isHidden = !isSwitchOn
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
    override func setting() {
        super.setting()
        
        settingView.layer.cornerRadius = 10
        settingView.controlSwitch.addTarget(self, action: #selector(switchClicked), for: .valueChanged)
        timeView.timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
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
                        print("(realm 대비) 현재 메인쓰레드? : ", OperationQueue.current == OperationQueue.main)
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
                    self.showAlert(
                        String(localized: "시스템 알림 설정이 해제되어 있습니다"),
                        message: String(localized: "원하는 시간에 알림을 받기 위해서 알림을 허용해주세요"),
                        okTitle: String(localized: "설정으로 이동")) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    sender.setOn(false, animated: true)
                    
                }
            }
            
            
        }
        
    }
    
}



