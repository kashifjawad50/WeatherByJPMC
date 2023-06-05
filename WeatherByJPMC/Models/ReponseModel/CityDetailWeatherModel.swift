//
//  CityDetailWeatherModel.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let description : String
    let icon: String
    let id : Int
}
