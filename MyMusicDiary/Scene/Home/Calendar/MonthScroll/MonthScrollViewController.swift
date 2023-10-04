//
//  MonthScrollViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit



class MonthScrollViewController: BaseViewController {
    
    let allMonth = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let allYear = [2021, 2022, 2023]
    

    let repository = MusicItemTableRepository()

    let mainView = MonthScrollView()

    var dataSource: UICollectionViewDiffableDataSource<String, DayItemTable>?

    let data: Observable<[DayItemTable]> = Observable([])

    var currentPageDate = Date()    // 이전 화면에서 값 받기
    let titleButton = UIButton()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let yearMonthDateFormatter = DateFormatter()
        yearMonthDateFormatter.dateFormat = "yyyyMM"
        
        let yearMonth = yearMonthDateFormatter.string(from: currentPageDate)
        
        data.value = repository.fetchMonth(yearMonth)!
        print(data.value)
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        
        let barbutton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonClicked))
        navigationItem.rightBarButtonItem = barbutton
        
        
        
        let monthYearDateFormatter = DateFormatter()
        monthYearDateFormatter.dateFormat = "MMMM yyyy"
        monthYearDateFormatter.locale = Locale.init(identifier: "en")
        let title = monthYearDateFormatter.string(from: currentPageDate)
        print(title)
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButton.addTarget(self, action: #selector(titleButtonClicked), for: .touchUpInside)
        
        navigationItem.titleView = titleButton
        
        settingPickerView()
    }
    
    
    func settingPickerView() {
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
    }
    
    @objc
    func titleButtonClicked() {
        print("hihi")
        mainView.pickerView.isHidden = false
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

extension MonthScrollViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return allMonth.count
        case 1:
            return allYear.count
        default:
            return 0
        }
    }
    
}
