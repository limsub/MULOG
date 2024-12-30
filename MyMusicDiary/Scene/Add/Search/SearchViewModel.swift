//
//  SearchViewModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation
import MusicKit


class SearchViewModel {
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    var page = 1
    var searchTerm: String?
    
    func fetchSearchMusic(completionHandler: @escaping () -> Void, noDataCompletionHandler: @escaping () -> Void) {
        guard let searchTerm else { return }
        Task {
            let status = await MusicAuthorization.request()
            
            switch status {
            case .notDetermined:
                break
            case .denied:
                break
            case .restricted:
                break
            case .authorized:
                do {
                    var request = MusicCatalogSearchRequest(
                        term: searchTerm,
                        types: [Song.self]
                    )
                    request.limit = 25
                    request.offset = (page-1)*25
                    
                    let result = try await request.response()
                    
                    completionHandler()
                    
                    print("--------------------------------------------------------------------")
                    print(result)
                    print("--------------------------------------------------------------------")
                    
                    self.musicList.value.append(contentsOf:
                        result.songs.map {
                            return .init(
                                id: $0.id.rawValue,
                                name: $0.title,
                                artist: $0.artistName,
                                bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
                                smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
                                previewURL: $0.previewAssets?[0].url?.absoluteString,
                                genres: $0.genreNames,
                                backgroundColor: $0.artwork?.backgroundColor,
                                appleMusicURL: $0.url?.absoluteString
                            )
                            
                        }
                    )
                    
                    if musicList.value.isEmpty {
                        noDataCompletionHandler()
                    }
                    
                }
            @unknown default:
                fatalError()
            }
            
            
        }
    }
    
    
    func fetchMusic(_ term: String) {
        
        Task {
            let status = await MusicAuthorization.request() // 나중에 첫화면으로 옮기기
            
            switch status {
            case .authorized:
                do {
                    var request = MusicCatalogSearchRequest(
                        term: term,
                        types: [Song.self]
                    )
                    request.limit = 25
                    request.offset = 1

                    let result = try await request.response()

//                    // contentsOf : 배열에 배열을 붙인다
//                    self.musicList.value.append(
//                        contentsOf: result.songs.map({
//                            return .init(id: $0.id.rawValue, name: $0.title, artist: $0.artistName, imageURL: $0.artwork, previewURL: $0.previewAssets?[0].url, genres: $0.genreNames)
//                        })
//                    )
                    
//                    print(result.songs[0].title,  result.songs[0].artwork?.backgroundColor)
                    
                    self.musicList.value = result.songs.map({
                        return .init(
                            id: $0.id.rawValue,
                            name: $0.title,
                            artist: $0.artistName,
                            bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
                            smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
                            previewURL: $0.previewAssets?[0].url?.absoluteString,
                            genres: $0.genreNames,
                            backgroundColor: $0.artwork?.backgroundColor
                            
                        )
                    })
                    
//                    print(musicList.value)
                } catch {
                    print("에러 발생", error)
                }


            // 안되는 케이스 둘 다 예전에 사진/카메라 권한 요청했던 수업 자료 확인하기 (단계별 설정)
            // 근데 뮤직 앱 권한 설정은 어떻게 하는지 자세하게는 잘 모르겠네
            case .denied:
                print("거절당함")
            case .notDetermined:
                print("아직 결정 안함")
            case .restricted:
                print("뭐야 이건")
            @unknown default:
                print("에러 에러", fatalError())
            }

        }
        
    }
}
