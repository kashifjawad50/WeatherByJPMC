//
//  SearchCityRequest.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation

enum SearchCityRequest {
    static func makeRequest(parameters: String) -> URLRequest?{
        guard let url = URL(string:  (Constants.baseURLSearchCity + parameters).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else{
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.getMethod
        request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
        return request
    }
}
