//
//  ChangeDateView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit


class ChangeMonthView: BaseView {
    
    let monthLabel = {
        let view = UILabel()
        view.text = "2023년 10월"
        return view
    }()
    let prevButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return view
    }()
    let nextButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return view
    }()
    
    let songsCountlabel = {
        let view = UILabel()
        view.text = "곡 수 : 9개"
        return view
    }()
    
    let genresCountLabel = {
        let view = UILabel()
        view.text = "장르 수 : 12개"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        
        addSubview(monthLabel)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(songsCountlabel)
        addSubview(genresCountLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
            make.height.equalTo(20)
        }
        prevButton.snp.makeConstraints { make in
            make.trailing.equalTo(monthLabel.snp.leading).inset(-8)
            make.centerY.equalTo(monthLabel)
            make.height.equalTo(20)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(monthLabel.snp.trailing).offset(8)
            make.centerY.equalTo(monthLabel)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        songsCountlabel.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(-50)
        }
        genresCountLabel.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(50)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    
    func setView(day: Date, musicCnt: Int, genreCnt: Int) {
        monthLabel.text = day.toString(of: .yearMonth)
        songsCountlabel.text = "곡 수 : \(musicCnt) 개"
        genresCountLabel.text = "장르 수 : \(genreCnt) 개"
    }
    
}
