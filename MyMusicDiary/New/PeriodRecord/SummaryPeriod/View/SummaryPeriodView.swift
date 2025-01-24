//
//  SummaryPeriodView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit

class SummaryPeriodView: BaseView {
    
    let summaryView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let showSelectMusicViewButton = UIButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        [summaryView, showSelectMusicViewButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        summaryView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(summaryView.snp.width)
        }
        
        showSelectMusicViewButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func setting() {
        super.setting()
        
        showSelectMusicViewButton.backgroundColor = .red
        
        self.backgroundColor = .white
    }
    
}
