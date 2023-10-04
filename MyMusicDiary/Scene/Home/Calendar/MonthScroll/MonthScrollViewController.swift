//
//  MonthScrollViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

class MonthScrollViewController: BaseViewController {

    let repository = MusicItemTableRepository()

    let mainView = MonthScrollView()

    var dataSource: UICollectionViewDiffableDataSource<String, DayItemTable>?

    let data: Observable<[DayItemTable]> = Observable([])


    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        data.value = repository.fetchMonth("202310")!
        print(data.value)
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        
        let barbutton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonClicked))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    @objc
    func buttonClicked() {
        dismiss(animated: true)
    }

}

extension MonthScrollViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value[section].musicItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthScrollCatalogCell.description(), for: indexPath) as? MonthScrollCatalogCell else { return UICollectionViewCell() }
        
        
        cell.designCell(data.value[indexPath.section].musicItems[indexPath.item], day: data.value[indexPath.section].day, indexPath: indexPath)
        
        return cell
        
    }

    
}
