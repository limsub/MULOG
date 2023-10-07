//
//  ChangeDateView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit


class CustmTitleView: BaseView {
    
    let dateLabel = {
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
        
        
        addSubview(dateLabel)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(songsCountlabel)
        addSubview(genresCountLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
            make.height.equalTo(20)
        }
        prevButton.snp.makeConstraints { make in
            make.trailing.equalTo(dateLabel.snp.leading).inset(-8)
            make.centerY.equalTo(dateLabel)
            make.size.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.centerY.equalTo(dateLabel)
            make.size.equalTo(50)
        }
        
        songsCountlabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(-50)
        }
        genresCountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(50)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    
    func setView(startDay: Date, musicCnt: Int, genreCnt: Int, type: ChartType) {
        if type == .month {
            dateLabel.text = startDay.toString(of: .yearMonth)
        } else {
            let calendar = Calendar.current
            guard let endDay = calendar.date(byAdding: .day, value: +6, to: startDay) else { return }
            dateLabel.text = "\(startDay.toString(of: .full)) ~ \(endDay.toString(of: .full))"
        }
        songsCountlabel.text = "곡 수 : \(musicCnt) 개"
        genresCountLabel.text = "장르 수 : \(genreCnt) 개"
    }
    
    
}
