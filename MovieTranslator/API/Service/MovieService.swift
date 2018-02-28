//
//  MovieService.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieService {
    static var shared : MovieService {
        return MovieService()
    }
    
    func getMovies(page: Int, completion:@escaping arrayBlock) {
        
        let parameters = ["api_key" : apiKey, "page" : page] as [String : Any]
        
        _ = APIManager.shared.get(methodName: ApiMethod.movies.rawValue, parameters: parameters, completion: { (response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let dataArray = ResponseParser.parseToDataArray(response) else { completion(nil, ParsingError.parseError.rawValue); return }
            guard let movies = Mapper<MovieModel>().mapArray(JSONArray: dataArray) as [MovieModel]? else { completion(nil, ParsingError.getDataError.rawValue) }
             completion(movies, nil)
        })
    }
    
    func searchMovies(query: String,page: Int, completion:@escaping arrayBlock) {
        let parameters = ["query" : query, "api_key" : apiKey, "page" : page] as [String : Any]
        
        _ = APIManager.shared.get(methodName: ApiMethod.search.rawValue, parameters: parameters, completion: { (response, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            guard let dataArray = ResponseParser.parseToDataArray(response) else { completion(nil, ParsingError.parseError.rawValue); return }
            guard let searchMovies = Mapper<MovieModel>().mapArray(JSONArray: dataArray) as [MovieModel]? else { completion(nil, ParsingError.getDataError.rawValue) }
            
            completion(searchMovies, nil)
        })
    }
    
    func getMoviePrimaryInfo(byMovieID id: Int, appendToResponse: String, completion:@escaping objectBlock) {
        let parameters = ["api_key" : apiKey, "append_to_response" : appendToResponse]
        
        _ = APIManager.shared.get(methodName: String(format:ApiMethod.movieInfo.rawValue, id) , parameters: parameters, completion: { (response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = ResponseParser.parseToDataObject(response) else { completion(nil, ParsingError.parseError.rawValue); return }
            
            if response?.response?.statusCode == 404 {
                completion(nil, data["error"] as? String)
            }
            
            guard let movieInfo = Mapper<MovieInfo>().map(JSON: data) else {completion(nil, ParsingError.parseError.rawValue); return}
            completion(movieInfo, error)
            
        })
        
    }
    
    func getGenreList(completion:@escaping objectBlock) {
        
        let parameters = ["api_key" : apiKey]
        
        _ = APIManager.shared.get(methodName: ApiMethod.genreList.rawValue, parameters: parameters, completion: { (response, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let data = ResponseParser.parseToDataObject(response) else { completion(nil, ParsingError.parseError.rawValue); return }
            
            if response?.response?.statusCode == 404 {
                completion(nil, data["error"] as? String)
            }
            guard let genreList = Mapper<GenreList>().map(JSON: data) else { completion(nil, ParsingError.parseError.rawValue); return }
            
            completion(genreList, nil)
            
        })

    }
    
    
    
        
    
}
