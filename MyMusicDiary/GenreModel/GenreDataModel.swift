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
    
    func isEmpty() -> Bool {
        return genres.isEmpty
    }
    
    func findGenre(_ type: GenreType) -> Genre? {
        
        if genres.isEmpty {
            print("findGenre fail. genre array is empty")
            return nil
        }
        
        for (_, item) in genres.enumerated() {
            if item.id.description == type.id {
                print("findGenre done")
                return item
            }
        }
        
        print("findGenre fail")
        return nil
    }
    
    
    
    
    func fetchGenreChart(_ completionHandler: @escaping () -> Void) {
        Task {
            let status = await MusicAuthorization.request()
            
            do {
//                let countryCode = try await MusicDataRequest.currentCountryCode
                guard let url = URL(string: "https://api.music.apple.com/v1/catalog/kr/genres") else { return }
                let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                let dataResponse = try await dataRequest.response()
                let decoder = JSONDecoder()
                let genreResponse = try decoder.decode(MyGenresResponse.self, from: dataResponse.data)
                
                for i in 1...13 {
                    genres.append(genreResponse.data[i])
                }
                
                
                print("fetchGenreChart done")
//                print(genres)
                completionHandler()
            } catch {
                print("에러에러")
            }
        }
    }
    
}
