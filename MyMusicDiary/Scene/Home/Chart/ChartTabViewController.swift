//
//  ChartTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit
import Tabman
import Pageboy


class ChartTabViewController: TabmanViewController {
    
    let monthChartVC = MonthChartViewController()
    let weekChartVC = WeekChartViewController()
    
    private lazy var viewControllers = [monthChartVC, weekChartVC]
    
    // Bar 부분을 담고 있기 위한 커스텀 뷰
    let customContainer = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")

        settingCustomContainer()
        settingNavigation()
        settingTabman()
    }
    
    func settingCustomContainer() {
        customContainer.backgroundColor = .clear
        customContainer.layer.applyShadow(color: Constant.Color.main2, alpha: 0.8, x: 0, y: 0.2, blur: 0.5)
        
        view.addSubview(customContainer)
        customContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(50)
        }
    }
    
    func settingNavigation() {
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func settingTabman() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 0
        bar.backgroundView.style = .clear
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = Constant.Color.main2
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.cornerStyle = .eliptical
        bar.buttons.customize { button in
            button.tintColor = .lightGray
            button.selectedTintColor = Constant.Color.main2
        }
        
        bar.backgroundColor = .white
        bar.layer.cornerRadius = 10
        bar.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
        
        addBar(bar, dataSource: self, at: .custom(view: customContainer, layout: nil))
    }

}

extension ChartTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: (index == 0) ? String(localized: "월") : String(localized: "주"))        
    }
}
