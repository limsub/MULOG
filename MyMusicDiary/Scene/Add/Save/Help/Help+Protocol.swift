//
//  Help+Protocol.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import Foundation


// 버튼에 대한 액션을 pageViewController에서 해주기 위함. (화면전환, dismiss)
protocol NextPageProtocol: AnyObject {
    func goNext(_ current: HelpType)
    func dismiss()
}
