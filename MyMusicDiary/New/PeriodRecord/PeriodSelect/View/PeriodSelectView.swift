//
//  PeriodSelectVie.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit

class PeriodSelectView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(PeriodSelectTableViewCell.self , forCellReuseIdentifier: PeriodSelectTableViewCell.description())
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
//        self.backgroundColor = .red
        
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setting() {
        super.setting()
        
        
    }
    
}

class PeriodSelectTableViewCell: BaseTableViewCell {
    
    let dateLabel = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        [dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
