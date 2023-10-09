//
//  PagerViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/08.
//

import Foundation


class PagerViewModel {
    
    let repository = PagerViewDataRepository()
    
    var dataList: [MusicItemTable] = []
    
    func fetchData() {
        dataList = repository.fetchMusicForPagerView()
        
//        print(dataList)
    }
    
    func numberOfItems() -> Int {
        return dataList.count
    }
    
    func cellForItemAt(_ index: Int, completionHandler: @escaping (MusicItemTable) -> Void) {
        
        completionHandler(dataList[index])
    }
    
    func currentPreviewURL(_ currentIndex: Int) -> String? {
        if currentIndex >= dataList.count { return nil }
        return dataList[currentIndex].previewURL
    }
    
}
