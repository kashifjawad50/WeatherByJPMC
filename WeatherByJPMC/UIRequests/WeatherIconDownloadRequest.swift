//
//  WeatherIconDownloadRequest.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/3/23.
//


import Foundation

enum WeatherIconDownloadRequest {
    static func makeRequest(parameters: String) -> URLRequest?{
        guard let url = URL(string:  (Constants.baseURLDownloadIcon + parameters + Constants.imageExtension).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else{
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.getMethod
        request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
        return request
    }
}
