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
    }
    
    func setConfigure() { }
    func setConstraints() { }
    
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        
        return layout
    }
    

}
