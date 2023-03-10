//
//  GENetworkDataManager.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import Combine

enum GEAPIRequestType<I, S> {
    case nowPlaying(I)
    case popular(I)
    case topRated(I)
    case upcoming(I)
    case details(I)
    case query(S)
    case genre
}

class GENetworkDataManager {
    static let shared = GENetworkDataManager()
    private init() {}
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDataRequest<T: Codable>(_ requestType: GEAPIRequestType<Int, (String, Int)>, responseType: T.Type) -> Future<Bool, Error> {
        return Future { [weak self] promis in
            guard let self = self else {
                return promis(.failure(GEAPIError.invalidURL))
            }
            let query = self.prepareQuery(requestType)
            var cancellable = AnyCancellable({})
            cancellable = GENetworkWorker.shared.makeRequest(query: query)
                .sink { completion in
                switch completion {
                case .finished:break
                    //print("Finish")
                case .failure(let error):
                    print("failure \(error)")
                    return promis(.failure(error))
                }
            } receiveValue: { data in
                DispatchQueue.main.async {
                    guard let data = data else { return promis(.failure(GEAPIError.invalidResponse)) }
                    guard let response = self.responseParser(data, responseType: T.self) else {
                        return promis(.failure(GEAPIError.invalidResponse))
                    }
                    //debugPrint("### new objects \( (response as? Movies)?.results.count ?? 0) ")
                    let category = self.fatchCategory(requestType)
                    GEDatabaseManager.shared.saveData(response, category: category) {
                        cancellable.cancel()
                        return promis(.success(true))
                    }
                }
            } //.store(in: &self.cancellables)
        }
    }
    
    private func prepareQuery(_ requestType: GEAPIRequestType<Int, (String, Int)>) -> String {
        switch requestType {
        case .nowPlaying(let pageIndex):
            return "movie/now_playing?page=\(pageIndex)&"
        case .popular(let pageIndex):
            return "movie/popular?page=\(pageIndex)&"
        case .topRated(let pageIndex):
            return "movie/top_rated?page=\(pageIndex)&"
        case .upcoming(let pageIndex):
            return "movie/upcoming?page=\(pageIndex)&"
        case .details(let movieId):
            return "movie/\(movieId)?"
        case .query(let searchParams):
            let queryString = searchParams.0
            let pageIndex = searchParams.1
            return "search/movie?query=\(queryString)&page=\(pageIndex)&"
        case .genre:
            return "genre/movie/list?"
        }
    }
    
    private func fatchCategory(_ requestType: GEAPIRequestType<Int, (String, Int)>) -> String {
        switch requestType {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        case .details:
            return "details"
        case .query:
            return "query"
        case .genre:
            return "genre"
        }
    }
    
    private func responseParser<T: Codable>(_ data: Data, responseType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}
