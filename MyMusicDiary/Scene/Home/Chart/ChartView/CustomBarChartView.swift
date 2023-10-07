//
//  CustomBarChartView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit

struct A {
    let day: String?
    var genres: [String]?
}

struct B {
    let day: String?
    var genreCounts: [String:Int]?
    var allCount: Int
}

class CustomBarChartView: UIView {
    
//    var dataList: [A] = [
//        A(day: "20231010", genres: ["pop", "rock", "pop"] ),
//        A(day: "20231012", genres: ["k-pop", "rock", "pop"]),
//        A(day: "20231014", genres: ["pop", "ballad", "pop"])
//    ]
    
    var dataList: [B] = [
        B(day: "20231010", genreCounts: ["pop": 50, "rock": 10], allCount: 30),
        B(day: "20231012", genreCounts: ["k-pop": 10, "rock": 80, "pop": 30], allCount: 40),
        B(day: "20231014", genreCounts: ["pop": 20, "ballad": 90], allCount: 60),
        B(day: "20231014", genreCounts: ["pop": 20, "ballad": 90], allCount: 60),
        B(day: "20231014", genreCounts: ["pop": 20, "ballad": 90], allCount: 60),
        B(day: "20231014", genreCounts: ["pop": 20, "ballad": 90], allCount: 60),
        B(day: "20231014", genreCounts: ["pop": 20, "ballad": 90], allCount: 60),
    ]
    
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
        
        print("height : \(height), width : \(width)")
        
        // x축, y축은 생략
        
        // bar 그래프
        // 막대기의 맨 끝 y좌표
//        var yPositionArr = dataList.map { item in
//            return height - bottomSpace - topSpace - CGFloat(item.allCount)
//        }
        
        
        var yPositionDictArr: [Dictionary<String, CGFloat>] = []
        
        dataList.forEach { item in
            
            var a = Dictionary<String ,CGFloat>()
            
            var y = height - bottomSpace - topSpace
            
            for (key, value) in item.genreCounts! {
                
                a[key] = y - CGFloat(value)
                
                y -= CGFloat(value)
            }
            
            yPositionDictArr.append(a)
        }
        
        dump(yPositionDictArr)
        
        var x: CGFloat = leftSpace // 시작 x좌표
        let itemWidth = (width - x - rightSpace) / CGFloat(dataList.count)
        let barWidth = itemWidth * 0.7
        
        x += itemWidth / 2  // 가운데에 그림 그린다
        
        let colors: [UIColor] = [.red, .blue, .black, .green, .orange, .purple, .brown, .darkGray, .lightGray, .systemPink, .yellow]
        
        dataList.forEach { item in
            let dict = item.genreCounts!
            
            let startY = height - bottomSpace
            var currentY = startY
            
            for (key, value) in dict {
//                colors.randomElement()!.setStroke()
                
                colors.randomElement()?.setStroke()
                
                let barPath = UIBezierPath()
                barPath.lineWidth = barWidth
                barPath.move(to:
                    CGPoint(x: x, y: currentY)
                )
                barPath.addLine(to:
                    CGPoint(x: x, y: currentY - CGFloat(value))
                )
                
                currentY -= CGFloat(value)
                
                barPath.stroke()
                barPath.close()
                
            }
            
            x += itemWidth
        }
        
//        yPositionDictArr.forEach { dict in
//
//            let startY = height - bottomSpace
//            var currentY = startY
//
//            for (key, value) in dict {
//
//                colors.randomElement()!.setStroke()
//
//
//
//                let barPath = UIBezierPath()
//                barPath.lineWidth = barWidth
//                barPath.move(to:
//                    CGPoint(x: x, y: currentY)
//                )
//                barPath.addLine(to:
//                    CGPoint(x: x, y: currentY - CGFloat(value) )
//                )
//                barPath.stroke()
//                barPath.close()
//
//            }
//
//            x += itemWidth
//
//        }
        
        
    }
    
    
}
