//
//  SelectMusicViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit

class SelectMusicViewController: UIViewController {
    
    private let contentView = SelectMusicView()
    private var reactor: SelectMusicReactor!
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReactor()
        setupBindings()
    }
    
    private func setupReactor() {
        reactor = SelectMusicReactor()
    }
    
    private func setupBindings() {
        contentView.incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        contentView.decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    @objc private func incrementTapped() {
        reactor.increment()
        contentView.collectionView.reloadData()
    }
    
    @objc private func decrementTapped() {
        reactor.decrement()
        contentView.collectionView.reloadData()
    }
}

extension SelectMusicViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (contentView.collectionView.bounds.width - 8 * CGFloat(reactor.columns - 1)) / CGFloat(reactor.columns)
        return CGSize(width: side, height: side)
    }
}
