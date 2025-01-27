//
//  SummaryMonthVC.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit
import ReactorKit

class SummaryMonthViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    let mainView = SummaryMonthView()
    
    init(_ reactor: SummaryMonthReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - ReactorKit
extension SummaryMonthViewController {
    func bind(reactor: SummaryMonthReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SummaryMonthReactor) {
        
        mainView.reloadButton.rx.tap
            .map { SummaryMonthReactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.downloadButton.rx.tap
            .subscribe(with: self) { owner , _ in
                print("112341")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SummaryMonthReactor) {
        
    }
}

// MARK: - private func
extension SummaryMonthViewController {
    
}
