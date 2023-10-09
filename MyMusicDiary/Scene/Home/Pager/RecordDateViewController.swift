//
//  RecordDateViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/09.
//

import UIKit
import SnapKit

class RecordDateViewController: BaseViewController {
    
    var item: MusicItemTable?
    
    let countLabel = UILabel()
    
    let dateListLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        dateListLabel.numberOfLines = 0
        
        countLabel.text = "\(item?.count)번 기록한 음악입니다"
        
        var txt = "언제 기록했냐면"
        item?.dateList.forEach({ item in
            txt += "\n"
            txt += "\(item)"
            
        })
        dateListLabel.text = txt
        
    }
    
    override func setConfigure() {
        super.setConfigure()
            
        view.addSubview(countLabel)
        view.addSubview(dateListLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        countLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view).inset(20)
        }
        
        dateListLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view).inset(20)
        }
        
    }
}
