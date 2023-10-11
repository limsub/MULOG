//
//  UIViewController+Extension.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, message: String, okTitle: String, completionHandler: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    
    
    
     func createSaveLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        
        return layout
    }
    
    func createGenreSaveLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 100, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        return layout
    }
}



