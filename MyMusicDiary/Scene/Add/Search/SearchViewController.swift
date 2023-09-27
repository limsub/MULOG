//
//  SearchViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit


class SearchViewController: UIViewController {
    
    // ViewModel
    let viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bindModelData()
        viewModel.fetchMusic()
    }
    
    
    // bind
    func bindModelData() {
        viewModel.musicList.bind { _ in
            print("hi")
        }
    }
    
    
    
}
