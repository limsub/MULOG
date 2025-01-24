//
//  SelectMusicView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit

class SelectMusicView: UIView {
    
    // Collection View
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // Buttons
    let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        return button
    }()
    
    let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(collectionView)
        addSubview(decrementButton)
        addSubview(incrementButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // CollectionView layout
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor, constant: -36),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // Decrement Button layout
            decrementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            decrementButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            decrementButton.widthAnchor.constraint(equalToConstant: 48),
            decrementButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Increment Button layout
            incrementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            incrementButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            incrementButton.widthAnchor.constraint(equalToConstant: 48),
            incrementButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
