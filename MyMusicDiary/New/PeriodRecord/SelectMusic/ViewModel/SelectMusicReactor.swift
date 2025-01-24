//
//  SelectMusicReactor.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import Foundation

class SelectMusicReactor {
    
    private let numbers = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169]
    private var currentIndex = 0
    
    var numberOfItems: Int {
        return numbers[currentIndex]
    }
    
    var columns: Int {
        return Int(sqrt(Double(numbers[currentIndex])))
    }
    
    func increment() {
        if currentIndex < numbers.count - 1 {
            currentIndex += 1
        }
    }
    
    func decrement() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
