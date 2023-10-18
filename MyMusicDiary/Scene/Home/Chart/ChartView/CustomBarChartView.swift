//
//  CustomBarChartView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit

enum ChartType {
    case week
    case month
}

class CustomBarChartView: BaseView {
    
    // 주 -> 7
    // 월 -> 29, 30, 31
    // => Int 매개변수로 받기
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    func makeDayLabel(_ day: String) -> UILabel {
            
        let view = UILabel()
//        view.backgroundColor = .red
        view.textColor = .darkGray
        view.text = day
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        return view
    }
    
    lazy var day1Label = makeDayLabel("10/1")
    lazy var day2Label = makeDayLabel("10/15")
    lazy var day3Label = makeDayLabel("10/31")
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(day1Label)
        addSubview(day2Label)
        addSubview(day3Label)
        
    }
    override func setConstraints() {
        super.setConstraints()
        
//        let leftSpace: CGFloat = 20
//        let itemWidth = (self.frame.width - leftSpace * 2) / CGFloat(7)
//  
//        day1Label.snp.makeConstraints { make in
//            make.leading.equalTo(self).inset(20)
//            make.bottom.equalTo(self)
//            make.width.equalTo(30)
//        }
//        day2Label.snp.makeConstraints { make in
//            make.centerX.equalTo(self)
//            make.bottom.equalTo(self)
//            make.width.equalTo(30)
//        }
//        day3Label.snp.makeConstraints { make in
//            make.trailing.equalTo(self).inset(20)
//            make.bottom.equalTo(self)
//            make.width.equalTo(30)
//        }
    
    }
    
    var dataList: [DayGenreCountForBarChart] = []
    var dayCount: Int = 7   // 7 / 29, 30, 31
    var startDayString: String = "20231001"     //20231001
    
    var genres: [String] = []
    var colors: [String] = []
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func hi() {
//        draw(self.frame)
//    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 상하좌우 여백 -> SnapKit 따로 안쓴다
        let leftSpace: CGFloat = 18
        let rightSpace: CGFloat = 18
        let topSpace: CGFloat = 20
        let bottomSpace: CGFloat = 20
        
        // 상수
        let height = rect.height
        let width = rect.width
        
        var x: CGFloat = leftSpace // 시작 x좌표
        print("시작 위치 : \(x)")
        let itemWidth = (width - x - rightSpace) / CGFloat(dayCount)
        let barWidth = itemWidth * 0.8
        
        x += itemWidth / 2  // 가운데에 그림 그린다
        print("시작 위치 : \(x)")
        
        print("시작 위치 : \(x - barWidth / 2)")
        
//        let colors: [UIColor] = [.red, .blue, .black, .green, .orange, .purple, .brown, .darkGray, .systemPink, .yellow]
        
        // 한 줄씩 그림
        // for i 로 돌아야 할 것 같은데.. 7, 30이 고정되어있고, 없는 애들은 빈 칸으로 넘겨야 함
        
        /* 10/1 ~ 10/7
         10/1 -> o
         10/2 -> o
         10/5 -> ??
            - x를 2번 플러스 시켜버리고 그려
         
         */
        
        guard let startDayIntLet = Int(startDayString) else { return }
        var startDayInt = startDayIntLet    // 만약 중간에 빈 날짜가 있으면 하루씩 밀릴 예정
        
        for i in 0..<dayCount {
            if i >= dataList.count { return }
            
            let day = dataList[i].day
            let dayGenres = dataList[i].genreCounts
            
            let startY = height - bottomSpace
            var currentY = startY
            
            // day 작업
            if day != String(startDayInt + i) {
                var space: CGFloat = CGFloat(Int(day)! - (startDayInt + i))
                startDayInt += Int(space)   // 이후 배열에 맞춰주기 위해 아예 스타트 데이를 땡겨준다
                x += (itemWidth * space)    // 더하고 그려주자
            }
            
            
            for (key, value) in dayGenres {
                
                var barColor: UIColor = .lightGray
                
                for (index, name) in genres.enumerated() {
                    if key == name {
                        barColor = UIColor(hexCode: colors[index])
                    }
                }
                
                barColor.setStroke()
                
                let barPath = UIBezierPath()
                barPath.lineWidth = barWidth
                barPath.move(to:
                                CGPoint(x: x, y: currentY)
                )
                barPath.addLine(to:
                                    CGPoint(x: x, y: currentY - 15 * CGFloat(value))
                )
                currentY -= 15 * CGFloat(value)
                barPath.stroke()
                barPath.close()
            }
            
            x += itemWidth
        }
    }
}
