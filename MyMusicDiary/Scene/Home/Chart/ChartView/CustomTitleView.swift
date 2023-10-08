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
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        return view
    }()
    let prevButton = {
        let view = UIButton()
//        view.setImage(UIImage(named: "left-chevron"), for: .normal)
        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return view
    }()
    let nextButton = {
        let view = UIButton()
//        view.setImage(UIImage(named: "right-chevron"), for: .normal)
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return view
    }()
    
    let songsCountlabel = {
        let view = UILabel()
        let labelText = "곡 수\n9개"
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    
    let genresCountLabel = {
        let view = UILabel()
        view.text = "장르 수\n12개"
        view.numberOfLines = 2
        
        view.textAlignment = .center
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
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        prevButton.snp.makeConstraints { make in
            make.trailing.equalTo(dateLabel.snp.leading).inset(-8)
            make.centerY.equalTo(dateLabel)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.centerY.equalTo(dateLabel)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        songsCountlabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(18)
            make.leading.equalTo(self)
            make.trailing.equalTo(self.snp.centerX)
            
        }
        genresCountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(18)
            make.leading.equalTo(self.snp.centerX)
            make.trailing.equalTo(self)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    
    func setView(startDay: Date, musicCnt: Int, genreCnt: Int, type: ChartType) {
        if type == .month {
            let month = startDay.toString(of: .singleMonth)
            let year = startDay.toString(of: .year)
            
            dateLabel.text = "\(year)년 \(month)월"
            
        } else {
            let calendar = Calendar.current
            guard let endDay = calendar.date(byAdding: .day, value: +6, to: startDay) else { return }
            
            let start = startDay.toString(of: .fullSlashWithSingelMonth)
            let end = endDay.toString(of: .fullSlashWithSingelMonth)
            
            dateLabel.text = "\(start) ~ \(end)"
            
        }
        songsCountlabel.text = "곡 수\n\(musicCnt) 개"
        genresCountLabel.text = "장르 수\n\(genreCnt) 개"
    }
    
    
}
