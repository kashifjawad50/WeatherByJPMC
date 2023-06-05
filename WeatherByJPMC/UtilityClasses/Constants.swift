//
//  Constants.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation

enum Constants {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
    static let baseURLSearchCity = "http://api.openweathermap.org/geo/1.0/direct?q="
    static let baseURLDownloadIcon = "http://openweathermap.org/img/w/"
    static let cityRecordLimit = "&limit=20"
    static let appId = "&appid=b83c355404fc8ed6f1bf9dde29c19f10"
    static let getMethod = "Get"
    static let applicationJson = "application/json"
    static let contentType = "content-type"
    static let unitParameter = "&units="
    static let errorMessage = "Something went wrong"
    static let imageExtension = ".png"
}
