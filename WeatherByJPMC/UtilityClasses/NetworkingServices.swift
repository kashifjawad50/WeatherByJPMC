//
//  NetworkingServices.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation

final class NetworkingServices{
    
    typealias successResponse = (Data?)->()
    typealias errorResponse = (Error?)->()
    
    class func fetchCities(parameters: String, success: @escaping successResponse, fail: @escaping errorResponse) {
        
        guard let searchCityRequest = SearchCityRequest.makeRequest(parameters: parameters) else {
            return
        }
        
        self.load(request: searchCityRequest, success: success, fail: fail)
    }
    
    class func fetchCityDetailWeather(parameters: String, success: @escaping successResponse, fail: @escaping errorResponse) {
        
        guard let cityWeatherDetailRequest = CityWeatherDetailRequest.makeRequest(parameters: parameters) else {
            return
        }
        
        self.load(request: cityWeatherDetailRequest, success: success, fail: fail)
    }
    
    class func fetchWeatherIcon(parameters: String, success: @escaping successResponse, fail: @escaping errorResponse) {
        
        guard let weatherIconDownloadRequest = WeatherIconDownloadRequest.makeRequest(parameters: parameters) else {
            return
        }
        
        self.load(request: weatherIconDownloadRequest, success: success, fail: fail)
    }
    
    class func load(request: URLRequest, success: @escaping successResponse, fail: @escaping errorResponse) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return fail(error)
            }
            success(data)
        }.resume()
    }
}
