//
//  MonthScrollViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit


enum Month: Int, CaseIterable {

    case January
}


class MonthScrollViewController: BaseViewController {
    
    let allMonth = Array(1...12)
    let allYear = Array(2020...2030)
    
    var selectedYear = 1
    var selectedMonth = 2020
    
    
    

    let repository = MusicItemTableRepository()

    let mainView = MonthScrollView()

    var dataSource: UICollectionViewDiffableDataSource<String, DayItemTable>?

    let data: Observable<[DayItemTable]> = Observable([])

    var currentPageDate = Date()    // 이전 화면에서 값 받기
    let titleButton = UIButton()
    
    
    var isPickerViewHidden = true

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
        
        
        if !isPickerViewHidden {
            // 펼쳐져 있는 상태 -> 접어줘야 함
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
                [weak self] in
                self?.mainView.pickerView.backgroundColor = .clear
                self?.mainView.pickerView.frame = CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 0)
            } completion: { [weak self] _ in
                self?.mainView.pickerView.isHidden = true
                
                let yearMonthDateFormatter = DateFormatter()
                yearMonthDateFormatter.dateFormat = "yyyyMM"
                
                let yearMonth = yearMonthDateFormatter.string(from: self!.currentPageDate)
                
                if let v = self?.repository.fetchMonth(yearMonth)  {
                    self?.data.value = v
                } else {
                    self?.data.value.removeAll()
                }

                print(self?.data.value)
                
                self?.mainView.collectionView.reloadData()
            }

            
        } else {
            // 접혀 있는 상태 -> 펼쳐줘야 함
            
            mainView.pickerView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                [weak self] in
                self?.mainView.pickerView.backgroundColor = .lightGray
                self?.mainView.pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
            } completion: { _ in
                
            }
        }
        
        
        isPickerViewHidden.toggle()
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            
            let monthDateFormatter = DateFormatter()
            monthDateFormatter.dateFormat = "MMMM"
            let inverseDateFormatter = DateFormatter()
            inverseDateFormatter.dateFormat = "M"
            
            guard let date = inverseDateFormatter.date(from: String(allMonth[row])) else { return "" }
            
            return monthDateFormatter.string(from: date)
        case 1:
            return String(allYear[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedMonth = allMonth[row]
        case 1:
            selectedYear = allYear[row]
        default:
            break
        }
        
        let dateString: String
        if selectedMonth < 10 {
            dateString = "\(selectedYear)0\(selectedMonth)"
        } else {
            dateString = "\(selectedYear)\(selectedMonth)"
        }
        
        let yearMonthDateFormatter = DateFormatter()
        yearMonthDateFormatter.dateFormat = "yyyyMM"
        
        let d = yearMonthDateFormatter.date(from: dateString)
        print(d)
        
        if let currentPageDate = d {
            let monthYearDateFormatter = DateFormatter()
            monthYearDateFormatter.dateFormat = "MMMM yyyy"
            monthYearDateFormatter.locale = Locale.init(identifier: "en")
            let title = monthYearDateFormatter.string(from: currentPageDate)
            
            titleButton.setTitle(title, for: .normal)
            
            self.currentPageDate = currentPageDate
        }
        
        
        print(selectedMonth, selectedYear)
    }
    
    
}
