//
//  MonthScrollView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

extension UIView {
    func animateHiddenToLeft() {
            self.isHidden = false
            let identityX = center.x

            UIView.animateKeyframes(withDuration: 1.2, delay: 2) { [weak self] in
                guard let width = self?.bounds.width else {
                    return
                }
                self?.alpha = 0
                self?.center.x = -width/2
            } completion: { [weak self] _ in
                self?.alpha = 1
                self?.center.x = identityX
                self?.isHidden = true
            }
        }
    
    func animatedDisappearTop() {
        self.isHidden = false
        let identityY = center.y
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            [weak self] in
            
            guard let height = self?.bounds.height else { return }
            self?.alpha = 0
            self?.center.y = -height/2
        } completion: { [weak self] _ in
            self?.alpha = 1
            self?.center.y = identityY
            self?.isHidden = true
        }
    }
    

}

class MonthScrollView: BaseView {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout2())
    
    let pickerView = {
        let view = UIPickerView(frame: CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 0))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(collectionView)
        addSubview(pickerView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
//        pickerView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
//            make.height.equalTo(0)
//        }
    }
    override func setting() {
        super.setting()
        
        pickerView.isHidden = true
        
        backgroundColor = .systemBackground
        
        collectionView.register(MonthScrollCatalogCell.self, forCellWithReuseIdentifier: MonthScrollCatalogCell.description())
    }
    
    static func createLayout2() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        
        layout.minimumLineSpacing = 10
        
        return layout
    }

    
}
