//
//  HelpPageViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit
import SnapKit


class HelpPageViewController: BaseViewController {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    
//    var list = [HelpAlertViewController(), HelpAlertViewController(), HelpAlertViewController()]
//
//    var helpShowType: HelpShowType = .firstTime // 초기값은 일단 firstTime <- 값전달로 받을 예정
    
    let viewModel = HelpPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        viewModel.setVCType()
        
        viewModel.settingDelegate(self)
        
        settingPageVC()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(pageViewController.view)
    }
    override func setConstraints() {
        super.setConstraints()
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func settingPageVC() {
        guard let first = viewModel.firstVC() else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
}

extension HelpPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let typeCastVC = viewController as? HelpAlertViewController else { return nil }
        
        return viewModel.beforePage(typeCastVC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let typeCastVC = viewController as? HelpAlertViewController else { return nil }
        
        return viewModel.afterPage(typeCastVC)
    }
    
}


extension HelpPageViewController: NextPageProtocol {
    func goNext(_ current: HelpType) {
        
        switch current {
        case .drag:
            pageViewController.setViewControllers([viewModel.list[1]], direction: .forward, animated: true)
        case .representative:
            pageViewController.setViewControllers([viewModel.list[2]], direction: .forward, animated: true)
        case .delete:
            dismiss(animated: true)
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

