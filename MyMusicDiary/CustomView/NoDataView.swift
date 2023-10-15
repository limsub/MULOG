//
//  NoMusicView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/15.
//

import UIKit


class NoDataView: BaseView {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.opacity = 0.5
        return view
    }()
    
    let label = {
        let view = UILabel()
        view.textColor = .lightGray
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 16)
        view.numberOfLines = 0
        return view
    }()
    
    convenience init(imageName: String, labelStatement: String, imageSize: Int) {
        self.init()
        
        
        imageView.image = UIImage(named: imageName)
        label.text = labelStatement
        
        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.size.equalTo(imageSize)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
    }
        
    
    
}
