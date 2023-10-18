//
//  BaseViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import SnapKit


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { }
}
