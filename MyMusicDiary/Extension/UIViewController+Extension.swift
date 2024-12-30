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
        let cancel = UIAlertAction(title: String(localized: "취소"), style: .cancel)
        
        
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func showSingleAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: String(localized: "확인"), style: .default)
    
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    
    func showAlertTwoCases(_ title: String, message: String, okCompletionHandler: @escaping () -> Void, cancelCompletionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: String(localized: "확인"), style: .default) { _ in
            okCompletionHandler()
        }
        let cancel = UIAlertAction(title: String(localized: "취소"), style: .cancel) { _ in
            cancelCompletionHandler()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    
    
 
    

}



