//
//  Genre1ViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import Foundation
import MusicKit



class Genre1ViewModel {
    
    var myGenre = GenreDataModel.shared.genres[0]
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    func fetchMusic() {
        Task {
            var request = MusicCatalogChartsRequest(
                genre: myGenre,
                kinds: [.cityTop],
                types: [Song.self]
            )
            request.limit = 25
            request.offset = 1
            
            let result = try await request.response()
            
            self.musicList.value = result.songCharts[0].items.map {
                return .init(
                    id: $0.id.rawValue, name: $0.title, artist: $0.artistName,
                    bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
                    smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
                    previewURL: $0.previewAssets?[0].url, genres: $0.genreNames,
                    backgroundColor: $0.artwork?.backgroundColor
                )
            }
        }
    }
    
}
