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
    
    func showSingleAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
    
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    
    
 
    

}



