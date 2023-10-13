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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        
        monthChartVC.delegate = self
        weekChartVC.delegate = self
        
        
//        view.addSubview(button)
//        button.snp.makeConstraints { make in
//            make.center.equalTo(view)
//            make.size.equalTo(200)
//        }
//        button.backgroundColor = .red
//        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        tabBarController?.tabBar.backgroundColor = .white
        
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
//        bar.layout.interButtonSpacing = 20
//        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bar.backgroundView.style = .clear
        
        bar.indicator.overscrollBehavior = .compress
        
        bar.indicator.tintColor = Constant.Color.main2
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.cornerStyle = .eliptical

        
        bar.buttons.customize { button in
            button.tintColor = .lightGray
            button.selectedTintColor = Constant.Color.main2
        }
        
        bar.backgroundColor = .white
        bar.layer.cornerRadius = 20
        bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        

        
//        bar.layer.borderColor = UIColor.black.cgColor
//        bar.layer.borderWidth = 2
        print("aaa", bar.frame.width)
        

        addBar(bar, dataSource: self, at: .top)
        
        
        print("aaa", bar.frame.width)
        
            
        bar.layer.addBorder([.bottom], color: Constant.Color.main2, width: 1)  // addBar 이후에 적어야 width가 잡힌다!!
        
        
        
        
        view.layer.borderColor = UIColor.red.cgColor
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
