//
//  RecordDateViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/09.
//

import UIKit
import SnapKit


class CustomCollectionHeaderView: UICollectionReusableView {
    
    let label = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.verticalEdges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


class RecordDateViewController: BaseViewController {

    let viewModel = RecordDateViewModel()
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createDateLayout())
        
        view.register(RecordDateCollectionViewCell.self, forCellWithReuseIdentifier: RecordDateCollectionViewCell.description())
        
        view.register(
            CustomCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomCollectionHeaderView.description()
        )
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = UIColor(hexCode: "F6F6F6")
        
        return view
    }()
    
    func createDateLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 60
        
        layout.itemSize = CGSize(width: width/4, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
    
        
        
    
        return layout
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setDataList()
        
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        collectionView.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
   
        title = viewModel.countText()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 26, weight: .heavy)]
        
//        UIFont.boldSystemFont(ofSize: 26)
        navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        
        
        viewModel.sortDateList()
        
    }
    
    override func setConfigure() {
        super.setConfigure()
            
   
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    

}

extension RecordDateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dateList[section].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordDateCollectionViewCell.description(), for: indexPath) as? RecordDateCollectionViewCell else { return UICollectionViewCell() }
        
//        cell.dateLabel.text = viewModel.cellForItem(indexPath)
        
        cell.designCell(viewModel.dateList[indexPath.section][indexPath.row])
        
//        cell.dateLabel.text = viewModel.dateList[indexPath.section][indexPath.row]
        
//        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("HIHIHI")
        
        print(kind == UICollectionView.elementKindSectionHeader)
        
        
        guard kind == UICollectionView.elementKindSectionHeader, // 헤더일때
          let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CustomCollectionHeaderView.description(),
            for: indexPath
          ) as? CustomCollectionHeaderView else { return UICollectionReusableView()}
    
            print("hiHIhihih'")
        
        
        guard let year = viewModel.sectionList[indexPath.section]?.substring(from: 0, to: 3) else { return header }
        guard let month = viewModel.sectionList[indexPath.section]?.substring(from: 4, to: 5) else { return header }
        
        let title = String(localized: "\(year)년 \(month)월")
        header.label.text = title

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
    
}
