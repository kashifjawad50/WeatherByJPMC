//
//  LocationBasedCityModel.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation

struct CityDetail: Codable {
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias Cities = [CityDetail]

