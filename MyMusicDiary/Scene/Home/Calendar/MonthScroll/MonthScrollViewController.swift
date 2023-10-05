//
//  MonthScrollViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

class MonthScrollViewController: BaseViewController {
    
    let allYear = Array(2020...2030)
    let allMonth = Array(1...12)
    
//    var selectedYear = 2020
//    var selectedMonth = 1
    
    
    let repository = MusicItemTableRepository()

    let mainView = MonthScrollView()

    let data: Observable<[DayItemTable]> = Observable([])

    var currentPageDate = Date()    // 이전 화면에서 값 받기
    
    let titleButton = UIButton()    // navigation Item에 들어가는 버튼
    
    var isPickerViewHidden = true

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingNavigaionItem()
        settingCollectionView()
        settingPickerView()

        
        updateData()
        setMonthYear()
    }
    
    
    func setMonthYear() {
        // (x) currentPageData로 selected Year, Month 지정
        guard let year = Int(currentPageDate.toString(of: .year)) else { return }
        guard let month = Int(currentPageDate.toString(of: .singleMonth)) else { return }

        // selected Year, Month로 pickerView의 초기 선택값 지정
        guard let selectedYearIndex = allYear.firstIndex(of: year) else { return }
        guard let selectedMonthIndex = allMonth.firstIndex(of: month) else { return }

        mainView.pickerView.selectRow(selectedMonthIndex, inComponent: 0, animated: false)
        mainView.pickerView.selectRow(selectedYearIndex, inComponent: 1, animated: false)
    }
    
    func updateData() {
        let yearMonth = currentPageDate.toString(of: .yearMonth)
        
        if let newData = repository.fetchMonth(yearMonth) {
            data.value = newData
        } else {
            data.value.removeAll()
        }
    }
    
    func settingNavigaionItem() {
        // right Button
        let barbutton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonClicked))
        navigationItem.rightBarButtonItem = barbutton
        
        // titleView
        let title = currentPageDate.toString(of: .fullMonthYear)
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButton.addTarget(self, action: #selector(titleButtonClicked), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    
    func settingCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
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
                // animation
                self?.mainView.pickerView.backgroundColor = .clear
                self?.mainView.pickerView.frame = CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 0)
            } completion: { [weak self] _ in
                self?.mainView.pickerView.isHidden = true   // hidden 처리
                self?.updateData()    // 선택한 날짜로 데이터 업데이트
                self?.mainView.collectionView.reloadData() // collectionView reload
                self?.setMonthYear()    // pickerView 초기값 지정
            }
        } else {
            // 접혀 있는 상태 -> 펼쳐줘야 함
            mainView.pickerView.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
                [weak self] in
                // animation
                self?.mainView.pickerView.backgroundColor = .lightGray
                self?.mainView.pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
            }
        }
        
        isPickerViewHidden.toggle()
    }
    
    @objc
    func buttonClicked() {
        dismiss(animated: true)
    }

}


// collectionView
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



// pickerView
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
            // allMonth -> 8, 9, 10, 11 => MM으로 만들어줘야 함 (int -> String -> date)
            // MM => MMMM으로 만들어줘야 함 (date -> string)
            let month = allMonth[row]   // Int
            let monthString = (month < 10) ? "0\(month)" : "\(month)"   // String
            let monthDate = monthString.toDate(to: .month)  // Date
            let ansString = monthDate?.toString(of: .fullMonth) // String
            return ansString
        case 1:
            return String(allYear[row])
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // currentPageDate로
        guard let tmpYear = Int(currentPageDate.toString(of: .year)) else { return }
        guard let tmpMonth = Int(currentPageDate.toString(of: .singleMonth)) else { return }
        
        var selectedMonth = tmpMonth
        var selectedYear = tmpYear
        
        switch component {
        case 0:
            selectedMonth = allMonth[row]
        case 1:
            selectedYear = allYear[row]
        default:
            break
        }
        
        let dateString = (selectedMonth < 10) ? "\(selectedYear)0\(selectedMonth)" : "\(selectedYear)\(selectedMonth)"
        
        guard let newDate = dateString.toDate(to: .yearMonth) else { return }   // Date
        
        currentPageDate = newDate
        
        // titleButton은 실시간 업데이트
        let newTitle = newDate.toString(of: .fullMonthYear)
        titleButton.setTitle(newTitle, for: .normal)
    }
}
