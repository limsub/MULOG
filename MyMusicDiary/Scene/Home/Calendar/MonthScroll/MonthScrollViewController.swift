//
//  MonthScrollViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

class MonthScrollViewController: BaseViewController {
    
    /* view */
    let mainView = MonthScrollView()
    
    /* viewModel */
    let viewModel = MonthScrollViewModel()

    
    /* navigationItem 내부 */
    let titleButton = UIButton(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: 40)
    )    // navigation Item에 들어가는 버튼
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    let titleImage = {
        let view = UIImageView()
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold) // 이미지 두께 조절
        view.image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfiguration)!
        view.tintColor = .black
        view.sizeToFit()
        return view
    }()
    
    
    
    override func loadView() {
        self.view = mainView
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingNavigaionItem()
        settingCollectionView()
        settingPickerView()
        
        viewModel.updateData()
        setMonthYearForPickerView()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.largeTitleDisplayMode = .never
//    }
    
    func settingNavigaionItem() {
        
        navigationItem.largeTitleDisplayMode = .never
        
//        navigationController?.navigationBar.prefersLargeTitles = false
 
        // titleView
        titleLabel.text = viewModel.currentMonthYearTitle()
        
        titleButton.addSubview(titleLabel)
        titleButton.addSubview(titleImage)
        
        titleLabel.snp.makeConstraints { make in    // snapkit 레이아웃 잡은게 특이하긴 한데.. 돌아가긴 한다
            make.center.equalTo(titleButton)
        }
        titleImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(titleButton)
        }
        titleButton.snp.makeConstraints { make in
            make.width.equalTo(titleLabel).multipliedBy(1.4)
        }
        titleButton.addTarget(self, action: #selector(titleButtonClicked), for: .touchUpInside)
        navigationItem.titleView = titleButton

        
        // navigation item
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    func settingCollectionView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        mainView.collectionView.addGestureRecognizer(tapGestureRecognizer)
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }
    
    func settingPickerView() {
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
    }
    
    
    
    @objc   // pickerView 접어준다
    func didTapView(_ sender: UITapGestureRecognizer) {
        if !viewModel.pickerViewHiddenState() {
            foldPickerView()
            viewModel.togglePickerViewHidden()
        }
        print("taptap")
    }
    
    @objc   // pickerView 상태에 따라 접거나 펴준다
    func titleButtonClicked() {
        if !viewModel.pickerViewHiddenState() {
            // 펼쳐져 있는 상태 -> 접어줘야 함
            foldPickerView()
        } else {
            // 접혀 있는 상태 -> 펼쳐줘야 함
            unfoldPickerView()
        }
        viewModel.togglePickerViewHidden()  // pickerViewHidden 변수 토글
    }
    
    
    func foldPickerView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            [weak self] in
            // animation
            self?.mainView.backView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
            self?.mainView.pickerView.frame = CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 0)
            self?.mainView.pickerView.alpha = 0
            
            self?.titleLabel.textColor = .black
            self?.titleImage.transform = CGAffineTransform(rotationAngle: 0)
            
            self?.titleImage.tintColor = .black
        } completion: { [weak self] _ in
            self?.mainView.pickerView.isHidden = true   // hidden 처리
            self?.viewModel.updateData()    // 선택한 날짜로 데이터 업데이트
            self?.mainView.collectionView.reloadData() // collectionView reload
            self?.setMonthYearForPickerView()    // pickerView 초기값 지정
            self?.mainView.pickerView.alpha = 1
        }
    }
    
    func unfoldPickerView() {
        mainView.pickerView.isHidden = false
        setMonthYearForPickerView()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            [weak self] in
            // animation
            self?.mainView.backView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
            self?.mainView.pickerView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: 200)
            
            self?.titleLabel.textColor = .white
            self?.titleImage.transform = CGAffineTransform(rotationAngle: .pi/2)
            self?.titleImage.tintColor = .white
        } completion: { _ in
            print("unfold done")
        }
    }
  
    

    
    
    func setMonthYearForPickerView() {
        
        
        mainView.pickerView.selectRow(viewModel.currentMonthIdx(), inComponent: 0, animated: false)
        mainView.pickerView.selectRow(viewModel.currentYearIdx(), inComponent: 1, animated: false)
    }
}


// collectionView
extension MonthScrollViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthScrollCatalogCell.description(), for: indexPath) as? MonthScrollCatalogCell else { return UICollectionViewCell() }
        
        let item = viewModel.cellForItemData(indexPath)
        let day = viewModel.cellForItemDay(indexPath)
        
        cell.designCell(item, day: day, indexPath: indexPath)

        return cell
    }
}





// pickerView
extension MonthScrollViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent(component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(row: row, component: component)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 1. currentPageDate 업데이트      -> 함수 내에서 끝
        // 2. titleButton setTitle        -> 리턴값
        
        let newTitle = viewModel.didSelectRow(row: row, component: component)
        titleLabel.text = newTitle
//        titleButton.setTitle(newTitle, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let ansString = viewModel.attributedTitleForRow(row: row, component: component)
        
        return NSAttributedString(string: ansString ?? "", attributes: [.foregroundColor:UIColor.white])
    }
}
