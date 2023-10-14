//
//  GenreViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import Foundation
import MusicKit


class GenreViewModel {
    
    var genre: Genre?
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    var title: String?
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var currentPage: Int = 0
    
    var paginationDone = true
    
    
    
    var wholeData: [MusicItem] = []
    
    func fetchMusic() {
        Task {
            var request = MusicCatalogChartsRequest(
                genre: genre,
                kinds: [.cityTop],
                types: [Song.self]
            )
            request.limit = 150
            request.offset = 1
            
            let result = try await request.response()
            self.wholeData = result.songCharts[0].items.map {
                return .init(id: $0.id.rawValue, name: $0.title, artist: $0.artistName, bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString, smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString, previewURL: $0.previewAssets?[0].url?.absoluteString, genres: $0.genreNames, backgroundColor: $0.artwork?.backgroundColor)
            }
            
            
            for i in 0...24 {
                musicList.value.append(wholeData[i])
            }
            
            currentPage += 25
        }
    }
    
    
    
    // 1 -> 25까지, 2 -> 50까지, 3 -> 75까지, 4 -> 100까지
//    func title() -> String? {
//        return genre?.name
//    }
    
    
//    func fetchMusic(offset: Int) {
//        Task {
//
//            var request = MusicCatalogChartsRequest(
//                genre: genre,
//                kinds: [.cityTop],
//                types: [Song.self]
//            )
//            request.limit = 25
//            request.offset = offset
//
//
//
//            let result = try await request.response()
//            print(result)
//            print("offset: \(offset), 개수 : \(result.songCharts[0].items.count)")
//
//            if offset == 1 {
//                print("초기 데이터. 배열에 바로 넣기")
//                self.musicList.value = result.songCharts[0].items.map {
//                    return .init(
//                        id: $0.id.rawValue, name: $0.title, artist: $0.artistName,
//                        bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
//                        smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
//                        previewURL: $0.previewAssets?[0].url?.absoluteString, genres: $0.genreNames,
//                        backgroundColor: $0.artwork?.backgroundColor
//                    )
//                }
//            } else {
//                print("페이지네이션 데이터. 배열에 추가해주기")
//                // 특이한게, pagination을 하면 앞에 5개는 중복되는 걸 제공한다
//                // -> pagination 할 때만, 앞에 5개 제거하고 append하자
//
//                // 1. 일단 임시 배열에 저장
//                var tmpArr: [MusicItem] = result.songCharts[0].items.map {
//                    return .init(
//                        id: $0.id.rawValue, name: $0.title, artist: $0.artistName,
//                        bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
//                        smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
//                        previewURL: $0.previewAssets?[0].url?.absoluteString, genres: $0.genreNames,
//                        backgroundColor: $0.artwork?.backgroundColor
//                    )
//                }
//
//                // 2. 임시 배열의 앞에 5개 제거
//                for _ in 0...4 {
//                    tmpArr.remove(at: 0)
//                }
//
//                // 3. 실제 배열에 남은 임시 배열 append
//                self.musicList.value.append(contentsOf: tmpArr)
//
//            }
//
//            paginationDone = false
//
//
//        }
//    }
}
