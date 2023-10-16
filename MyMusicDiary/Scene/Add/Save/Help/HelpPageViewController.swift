//
//  HelpPageViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit
import SnapKit

// 몇 번째 페이지인지 구분하기 위함
enum HelpType {
    case drag
    case representative
    case delete
}

// 도움말 화면이 나오게 된 이유 -> 다시 보지 않기 버튼 히든처리해주기 위함
enum HelpShowType {
    case firstTime  // 첫 화면에 뜸
    case selectButton   // 도움말 버튼 눌러서 뜸
}


// 버튼에 대한 액션을 pageViewController에서 해주기 위함. (화면전환, dismiss)
protocol NextPageProtocol: AnyObject {
    func goNext(_ current: HelpType)
    func dismiss()
}

class HelpPageViewController: UIViewController {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var list = [HelpAlertViewController(), HelpAlertViewController(), HelpAlertViewController()]
    
    var helpShowType: HelpShowType = .firstTime

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        list[0].type = .drag
        list[1].type = .representative
        list[2].type = .delete
        
        list.forEach { item in
            item.nextPageDelegate = self
            
            switch helpShowType {
            case .firstTime:
                item.neverSeeButton.isHidden = false
                item.lineView.isHidden = false
            case .selectButton:
                item.neverSeeButton.isHidden = true
                item.lineView.isHidden = true
            }
        }
        
        guard let first = list.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

extension HelpPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = list.firstIndex(of: viewController as! HelpAlertViewController) else { return nil }
        return currentIndex <= 0 ? nil : list[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = list.firstIndex(of: viewController as! HelpAlertViewController) else { return nil }
        return currentIndex >= list.count - 1 ? nil : list[currentIndex + 1]
    }
    
}

extension HelpPageViewController: NextPageProtocol {
    func goNext(_ current: HelpType) {
        
        switch current {
        case .drag:
            pageViewController.setViewControllers([list[1]], direction: .forward, animated: true)
        case .representative:
            pageViewController.setViewControllers([list[2]], direction: .forward, animated: true)
        case .delete:
            dismiss(animated: true)
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

