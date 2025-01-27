//
//  RealmDataModified.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/15.
//

import Foundation

class RealmDataModified {
    
    static let shared = RealmDataModified()
    
    private init() { }
    
    
    var modifyProperty: CustomObservable<Bool> = CustomObservable(false)
    
    
}
