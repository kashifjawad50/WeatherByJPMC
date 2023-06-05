//
//  SearchCityViewModel.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation
import UIKit

class LocationBasedCityViewModel {
    typealias successResponse = (Cities?)->()
    typealias errorResponse = (Error?)->()
    
    func loadCitiesFromServer(parameters: String, successResonse: @escaping successResponse, errorResponse: @escaping errorResponse) {
        let params = parameters + Constants.cityRecordLimit + Constants.appId
        NetworkingServices.fetchCities(parameters: params) { data in
            guard let data = data else {
                return
            }
            
            successResonse(self.parseDataToModel(data)?.filter { $0.country.contains("US")})
        } fail: { error in
            errorResponse(error)
        }
        
    }
    
    func parseDataToModel(_ citiesData : Data) -> Cities? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Cities.self, from: citiesData)
            return decodedData
        } catch {
            print("Error while parsing")
            return nil
        }
    }
    
    func navigateToDetailViewController(cityDetail: CityDetail, unit: String, navigationContoller: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "CityWeatherDetailViewController",creator: { (aDecoder: NSCoder) -> CityWeatherDetailViewController in
            return CityWeatherDetailViewController(coder: aDecoder, cityDetail: cityDetail, unit: unit)!
        })
        navigationContoller.pushViewController(controller, animated: true)
    }
}

