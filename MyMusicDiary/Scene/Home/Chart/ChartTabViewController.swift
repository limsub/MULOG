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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        

        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 20
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bar.backgroundView.style = .clear
        
        addBar(bar, dataSource: self, at: .top)
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
        let title = "하이"
        return TMBarItem(title: title)
    }
}
