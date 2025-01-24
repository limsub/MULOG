//
//  SummaryPeriodViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit
import RxSwift

class SummaryPeriodViewController: BaseViewController {
    
    let mainView = SummaryPeriodView()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.showSelectMusicViewButton.rx.tap
            .subscribe(with: self) { owner , _ in
                let vc = SelectMusicViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
}
