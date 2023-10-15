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
    
    var previewURL: String?     // 재생할 url
    
    
    func fetchData(noDataCompletionHandler: @escaping (Bool) -> Void) {
        dataList = repository.fetchMusicForPagerView()
        
        // 데이터가 하나도 없으면 true
        let noData = dataList.isEmpty
        noDataCompletionHandler(noData)
    }
    
    func numberOfItems() -> Int {
        return dataList.count
    }
    
    func cellForItemAt(_ index: Int, completionHandler: @escaping (MusicItemTable) -> Void) {
        
        completionHandler(dataList[index])
    }
    
    func updatePreviewURL(_ currentIndex: Int) {
        if currentIndex >= dataList.count { return }
        previewURL = dataList[currentIndex].previewURL
    }
    
    func makeUrlByPreviewURL() -> URL? {
        guard let str = previewURL, let url = URL(string: str) else { return nil }
        return url
    }
    
    
    
    
    
}
