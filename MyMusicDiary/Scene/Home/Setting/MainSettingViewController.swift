//
//  MainSettingViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit

class MainSettingViewController: BaseViewController {
    
    let settingData = [["알림"], ["버그, 오류 제보", "문의"], ["개인정보 처리방침"] ]
    
    lazy var tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        
        view.backgroundColor = Constant.Color.background
        view.isScrollEnabled = false // 우선 스크롤할 일은 없다
        
        view.contentInset.left = 0
        view.contentInset.right = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.Color.background
        
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


extension MainSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = settingData[indexPath.section][indexPath.row]

        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .lightGray
        cell.accessoryView = imageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 알림 설정
        if indexPath == IndexPath(row: 0, section: 0) {
            let vc = NotificationSettingViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        }
        // 버그, 오류 제보
        else if indexPath == IndexPath(row: 0, section: 1) {
            if let url = URL(string: "https://forms.gle/NswcxpzvQ9hSoSmD6") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        else if indexPath == IndexPath(row: 1, section: 1) {
            if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfZdqKA8ahnLymVmoOpftc7yBBFO0WuOKvSLp0ulEfejFK4fA/viewform?usp=sf_link") {
                UIApplication.shared.open(url, options: [:])
            }
        }
                    
        // 개인정보 처리방침
        else if indexPath == IndexPath(row: 0, section: 2) {
            
            let vc = PrivarcyViewController()
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
