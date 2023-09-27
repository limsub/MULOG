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
    
    
    func fetchMusic() {
        
        Task {
            let status = await MusicAuthorization.request() // 나중에 첫화면으로 옮기기
            
            switch status {
            case .authorized:
                do {
                    var request = MusicCatalogSearchRequest(
                        term: "blackPink",
                        types: [Song.self]
                    )
                    request.limit = 25
                    request.offset = 1

                    let result = try await request.response()

                    // contentsOf : 배열에 배열을 붙인다
                    self.musicList.value.append(
                        contentsOf: result.songs.map({
                            return .init(id: $0.id.rawValue, name: $0.title, artist: $0.artistName, imageURL: $0.artwork, previewURL: $0.previewAssets?[0].url)
                        })
                    )
                    print(musicList.value)
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
