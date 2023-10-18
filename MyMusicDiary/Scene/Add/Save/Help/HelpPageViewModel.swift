//
//  HelpPageViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import Foundation

class HelpPageViewModel {
    
    
    var list = [HelpAlertViewController(), HelpAlertViewController(), HelpAlertViewController()]
    
    var helpShowType: HelpShowType = .firstTime // 초기값은 일단 firstTime <- 값전달로 받을 예정
    
    func setVCType() {
        // 각 뷰컨의 타입 지정
        list[0].type = .drag
        list[1].type = .representative
        list[2].type = .delete
        
        // 뷰컨에 진입한 상태에 따라 "다시 보지 않기" 레이블 처리
        list.forEach { item in

            switch helpShowType {
            case .firstTime:
                item.neverSeeButton.isHidden = false
                item.lineView.isHidden = false
            case .selectButton:
                item.neverSeeButton.isHidden = true
                item.lineView.isHidden = true
            }
        }
    }
    
    func firstVC() -> HelpAlertViewController? {
        return list.first
    }
    
    func settingDelegate(_ viewController: NextPageProtocol) {
        list.forEach { item in
            item.nextPageDelegate = viewController
        }
    }
    
    
    func beforePage(_ viewController: HelpAlertViewController) -> HelpAlertViewController? {
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        
        return currentIndex <= 0 ? nil : list[currentIndex - 1]
        
    }
    func afterPage(_ viewController: HelpAlertViewController) -> HelpAlertViewController? {
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        
        return currentIndex >= list.count - 1 ? nil : list[currentIndex + 1]
    }
}
