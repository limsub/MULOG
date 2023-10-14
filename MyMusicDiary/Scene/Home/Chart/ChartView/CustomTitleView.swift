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
        view.tintColor = .black
        return view
    }()
    let nextButton = {
        let view = UIButton()
//        view.setImage(UIImage(named: "right-chevron"), for: .normal)
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    let songLabel = {
        let view = UILabel()
        view.text = "곡 수"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Constant.Color.main2
        view.textAlignment = .center
        return view
    }()
    let songsCountlabel = {
        let view = UILabel()
        view.text = "9개"
        view.font = .boldSystemFont(ofSize: 22)
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    let genresLabel = {
        let view = UILabel()
        view.text = "장르 수"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Constant.Color.main2
        view.textAlignment = .center
        return view
    }()
    let genresCountLabel = {
        let view = UILabel()
        view.text = "12개"
        view.font = .boldSystemFont(ofSize: 22)
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        
        addSubview(dateLabel)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(songLabel)
        addSubview(songsCountlabel)
        addSubview(genresLabel)
        addSubview(genresCountLabel)
        
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
//            make.width.equalTo(100)
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
        
        songLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalTo(self)
            make.trailing.equalTo(self.snp.centerX)
        }
        songsCountlabel.snp.makeConstraints { make in
            make.top.equalTo(songLabel.snp.bottom).offset(4)
            make.centerX.equalTo(songLabel)
        }
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalTo(songLabel.snp.trailing)
            make.trailing.equalTo(self)
        }
        genresCountLabel.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(4)
            make.centerX.equalTo(genresLabel)
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
            
            let start = startDay.toStringKorean(of: .fullSlashWithSingleMonthAndYoil)
            let end = endDay.toStringKorean(of: .fullSlashWithSingleMonthAndYoil)
            
            dateLabel.text = "\(start) ~ \(end)"
            
        }
        songsCountlabel.text = "\(musicCnt) 개"
        genresCountLabel.text = "\(genreCnt) 개"
    }
    
    
}
