//
//  BaseTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() { }
}

extension BaseTableViewCell {
    func makeGenreStr(_ genres: [String]) -> String  {
        var str = ""
        for (idx, genre) in genres.enumerated() {
            if (idx != genres.count - 1) {
                str += "\(genre) · "
            } else {
                str += "\(genre)"
            }
        }
        return str
    }
}
