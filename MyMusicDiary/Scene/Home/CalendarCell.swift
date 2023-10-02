//
//  CalendarCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarCell: FSCalendarCell {
    
    var backImageView = {
        let view = UIImageView()
        
//        view.image = UIImage(named: "sample1")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = [.red, .clear].randomElement()!
        view.clipsToBounds = true
        
        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.purple.cgColor
        
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 날짜 텍스트가 디폴트로 약간 위로 올라가 있어서, 아예 레이아웃을 잡아준다
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.insertSubview(backImageView, at: 0)
        backImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(minSize())
        }
        backImageView.layer.cornerRadius = minSize()/2
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
            
        
        
    }
    
    func minSize() -> CGFloat {
        let width = contentView.bounds.width - 5
        let height = contentView.bounds.height - 5

        return (width > height) ? height : width
    }
    
}
