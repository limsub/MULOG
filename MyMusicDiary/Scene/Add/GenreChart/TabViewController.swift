//
//  TabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import Tabman
import Pageboy

class TabViewController: TabmanViewController {
    
    private var viewControllers = [Genre1ViewController(), Genre2ViewController(), Genre3ViewController(), Genre4ViewController(), Genre5ViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        print(GenreDataModel.shared.genres)
        
        
        
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 30
        
        
        

        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        bar.backgroundView.style = .clear
        
        
        addBar(bar, dataSource: self, at: .top)
    }
    
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let title = GenreDataModel.shared.genres[index].name
        return TMBarItem(title: title)
    }
    
    
}
