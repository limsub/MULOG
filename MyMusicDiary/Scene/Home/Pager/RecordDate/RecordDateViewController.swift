//
//  RecordDateViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/09.
//

import UIKit
import SnapKit

class RecordDateViewController: BaseViewController {

    let viewModel = RecordDateViewModel()
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createDateLayout())
        
        view.register(RecordDateCollectionViewCell.self, forCellWithReuseIdentifier: RecordDateCollectionViewCell.description())
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    func createDateLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 40
        
        layout.itemSize = CGSize(width: width/2, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
    
    let countLabel = {
        let view = UILabel()
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        viewModel.sortDateList()
        fillLabel()
    }
    
    override func setConfigure() {
        super.setConfigure()
            
        view.addSubview(countLabel)
        view.addSubview(dateLabel)
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view).inset(24)
            make.horizontalEdges.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func fillLabel() {
        countLabel.text = viewModel.countText()
        dateLabel.text = "언제 기록했냐면"
    }
}

extension RecordDateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordDateCollectionViewCell.description(), for: indexPath) as? RecordDateCollectionViewCell else { return UICollectionViewCell() }
        
        cell.dateLabel.text = viewModel.cellForItem(indexPath)
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    
}
