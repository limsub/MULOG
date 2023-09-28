//
//  GenreDataModel.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import Foundation
import MusicKit

struct MyGenresResponse: Decodable {
    let data: [Genre]
}

class GenreDataModel {
    
    static let shared = GenreDataModel()
    private init() { }
    
    var genres: [Genre] = []
    
    
    func fetchGenreChart() {
        Task {
            let status = await MusicAuthorization.request()
            
            do {
//                let countryCode = try await MusicDataRequest.currentCountryCode
                guard let url = URL(string: "https://api.music.apple.com/v1/catalog/kr/genres") else { return }
                let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                let dataResponse = try await dataRequest.response()
                let decoder = JSONDecoder()
                let genreResponse = try decoder.decode(MyGenresResponse.self, from: dataResponse.data)
                
                for i in 1...5 {
                    genres.append(genreResponse.data[i])
                }
                
                print(genres)
                
            } catch {
                print("에러에러")
            }
        }
    }
    
}
