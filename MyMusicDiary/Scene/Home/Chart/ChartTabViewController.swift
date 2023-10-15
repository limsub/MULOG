//
//  ChartTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit
import Tabman
import Pageboy

protocol LargeTitleDelegate: AnyObject {
    func setLargeTitle()
    func setSmallTitle()
}

class ChartTabViewController: TabmanViewController, LargeTitleDelegate {
    
    let monthChartVC = MonthChartViewController()
    let weekChartVC = WeekChartViewController()
    
    private lazy var viewControllers = [monthChartVC, weekChartVC]
    
    
   
  
    
    func setLargeTitle() {
        print(#function)
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        
//        navigationController?.setNavigationBarHidden(false, animated: true)
//
//        let v = viewControllers[0] as! MonthChartViewController
//        v.reloadInputViews()
        
//        navigationController?.navigationBar.isHidden = false
        
//        viewControllers.forEach { vc in
//            vc.view.contentInset = UIEdgeInsetsMake(self.navigationController!.navigationBar.bounds.size.height, 0, 0, 0);
//
//            view.safeAreaInsets
//
//
//            print(view.safeAreaInsetsDidChange())
//        }
        
//        let v = viewControllers[0] as! MonthChartViewController
//        v.scrollView.contentInset = UIEdgeInsets(top: self.navigationController!.navigationBar.bounds.size.height, left: 0, bottom: 0, right: 0);
        
        
        
        
//        self.view.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height, 0, 0, 0);
        
    }
    func setSmallTitle() {
        print(#function)
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.largeTitleDisplayMode = .automatic
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        
//        let v = viewControllers[0] as! MonthChartViewController
//        v.scrollView.contentInset = UIEdgeInsets(top: self.navigationController!.navigationBar.bounds.size.height, left: 0, bottom: 0, right: 0);
//
        
//        self.view.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
//        navigationController?.navigationBar.isHidden = false
        
        
        
//        let v = viewControllers[0] as! MonthChartViewController
//
//        v.scrollView.automaticallyAdjustsScrollIndicatorInsets = true
//        v.scrollView.scrollsToTop = true
    }
    
    
//    let button = UIButton()
//    @objc
//    func buttonClicked() {
//        print("hi")
//
//        a.toggle()
//        if a {
//            navigationItem.largeTitleDisplayMode = .never
//        } else {
//            navigationItem.largeTitleDisplayMode = .always
//        }
//    }
//    var a = false
    
    
    let customContainer = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(customContainer)
        customContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(50)
        }
        customContainer.backgroundColor = .clear
        
        customContainer.layer.applyShadow(color: Constant.Color.main2, alpha: 0.8, x: 0, y: 0.2, blur: 0.5)
//        customContainer.layer.cornerRadius = 20

        
        monthChartVC.delegate = self
        weekChartVC.delegate = self
        

        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        tabBarController?.tabBar.backgroundColor = .white
        
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = UIScreen.main.bounds.width/2
//        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
//        bar.layer.backgroundColor = UIColor.red.cgColor
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
        if index == 0 {
            return TMBarItem(title: "월")
        } else {
            return TMBarItem(title: "주")
        }
    }
}
