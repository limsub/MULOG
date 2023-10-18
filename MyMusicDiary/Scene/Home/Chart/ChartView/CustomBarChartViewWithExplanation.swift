//
//  CustomBarChartViewWithExplanation.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit


class CustomBarChartDayLabelView: BaseView {
    
    static func makeDayLabel(_ str: String) -> UILabel {
        let view = UILabel()
        view.text = str
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 10)
        view.textAlignment = .center
//        view.backgroundColor = .red
        return view
    }
    
    let day1Label = makeDayLabel("10/1")
    let day2Label = makeDayLabel("10/2")
    let day3Label = makeDayLabel("10/3")
    let day4Label = makeDayLabel("10/4")
    let day5Label = makeDayLabel("10/5")
    let day6Label = makeDayLabel("10/6")
    let day7Label = makeDayLabel("10/7")
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func reDesign(_ type: ChartType, startDate: Date) {
        let dayArr = [day1Label, day2Label, day3Label, day4Label, day5Label, day6Label, day7Label]
        
        let calendar = Calendar.current
        
        switch type {
        case .week:
            for (index, label) in dayArr.enumerated() {
                var newDay = calendar.date(byAdding: .day, value: index, to: startDate)
                
                label.text = newDay?.toString(of: .slashMonthDay)
            }
            
        case .month:
            var components1 = calendar.dateComponents([.year, .month], from: startDate)
            guard let firstDay = calendar.date(from: components1) else { return }
            
            var components2 = calendar.dateComponents([.year, .month], from: startDate)
            components2.month = components2.month! + 1
            components2.day = 0
            guard let lastDay = calendar.date(from: components2) else { return }
            
            
            var components3 = calendar.dateComponents([.year, .month], from: startDate)
            components3.day = 15
            guard let middleDay = calendar.date(from: components3) else { return }
            
            day1Label.text = firstDay.toString(of: .slashMonthDay)
            day2Label.text = middleDay.toString(of: .slashMonthDay)
            day3Label.text = lastDay.toString(of: .slashMonthDay)
            
            day1Label.textAlignment = .left
            day3Label.textAlignment = .right
            
            day4Label.isHidden = true
            day5Label.isHidden = true
            day6Label.isHidden = true
            day7Label.isHidden = true
        }
    }
    
    
    convenience init(_ type: ChartType, startDate: Date) {
        self.init()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(stackView)
        stackView.addArrangedSubview(day1Label)
        stackView.addArrangedSubview(day2Label)
        stackView.addArrangedSubview(day3Label)
        stackView.addArrangedSubview(day4Label)
        stackView.addArrangedSubview(day5Label)
        stackView.addArrangedSubview(day6Label)
        stackView.addArrangedSubview(day7Label)
    }
    override func setConstraints() {
        super.setConstraints()
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            
        }
    }
}

class CustomBarChartViewWithExplanation: BaseView {
    
    let titleLabel = UILabel()
    var barChartView = CustomBarChartView()
    
    var barDateView: CustomBarChartDayLabelView = CustomBarChartDayLabelView(.month, startDate: Date())
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createBarCollectionLayout())
    
    
    private func createBarCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let width = UIScreen.main.bounds.width * 0.28
        let height: CGFloat = 20
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        
        return layout
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        
        
        
//        barChartView.backgroundColor = .lightGray
//        collectionView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConfigure() {
        super.setConfigure()
        self.addSubview(titleLabel)
        self.addSubview(barChartView)
        self.addSubview(collectionView)
        self.addSubview(barDateView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(12)
            make.leading.equalTo(self).inset(18)
        }
        barChartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(200)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(barChartView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self).inset(30)
        }
        barDateView.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.top).offset(-4)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(20)
        }
    }
}
