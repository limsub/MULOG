//
//  HelpPageViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit
import SnapKit

class HelpPageViewController: UIViewController {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var list = [HelpAlertViewController(), HelpAlertViewController(), HelpAlertViewController()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        list[0].type = .drag
        list[1].type = .representative
        list[2].type = .delete
        
        list.forEach { item in
            item.nextPageDelegate = self
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

protocol NextPageProtocol: AnyObject {
    func goNext(_ current: HelpType)
    
    func dismiss()
}
