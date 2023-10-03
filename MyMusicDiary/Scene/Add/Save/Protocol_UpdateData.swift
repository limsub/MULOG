//
//  Protocol_UpdateData.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import Foundation

protocol UpdateDataDelegate: AnyObject {
    // Save 화면의 데이터를 업데이트
    func updateMusicList(item: MusicItem)
}
