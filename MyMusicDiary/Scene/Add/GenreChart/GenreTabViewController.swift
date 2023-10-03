//
//  TabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import Tabman
import Pageboy

class GenreTabViewController: TabmanViewController {
    
    weak var delegate: UpdateDataDelegate?
    
    let v1 = Genre1ViewController()
    let v2 = Genre2ViewController()
    let v3 = Genre3ViewController()
    let v4 = Genre4ViewController()
    let v5 = Genre5ViewController()
    
    private lazy var viewControllers = [v1, v2, v3, v4, v5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        v1.delegate = delegate
        v2.delegate = delegate
        v3.delegate = delegate
        v4.delegate = delegate
        v5.delegate = delegate
        
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

extension GenreTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
