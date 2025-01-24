//
//  Logger.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/24/25.
//

import Foundation

class Logger {
    static func print(_ message: Any, file: String = #file, function: String = #function, terminator: String = "\n") {
        let className = (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        Swift.print("[\(className)] \(message)", terminator: terminator)
    }
}
