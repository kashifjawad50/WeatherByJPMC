//
//  CityWeatherDetailViewModel.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import Foundation
import UIKit

class CityWeatherDetailViewModel {
    typealias successResponse = (WeatherData?)->()
    typealias errorResponse = (Error?)->()
    
    init() {
    }
    
    func loadSelectedCityWeatherFromServer(cityName: String,unit: String, successResonse: @escaping successResponse, errorResponse: @escaping errorResponse) {
        let parameters =  cityName + "\(Constants.unitParameter)\(unit)" + Constants.appId
        NetworkingServices.fetchCityDetailWeather(parameters: parameters) { response in
            guard let data = response else {
                return
            }
            successResonse(self.parseDataToModel(data))
        } fail: { error in
            errorResponse(error)
        }
        
    }
    
    func parseDataToModel(_ weatherData : Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return decodedData
        } catch {
            print("Error while parsing")
            return nil
        }
    }
    
    func navigateToSearch(navigationContoller: UINavigationController, unit: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SearchCityViewController",creator: { (aDecoder: NSCoder) -> SearchCityViewController in
            return SearchCityViewController(coder: aDecoder, unit: unit)!
        })
        navigationContoller.pushViewController(controller, animated: true)
        
    }
    
    func changeTempratureUnit(controller: LocationBasedCityViewController) {
        let alert = UIAlertController(title: "Weather", message: "Please Select Temprature Unit", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: TempratureUnit.Celsius.rawValue, style: .default , handler:{ (UIAlertAction)in
            controller.tempratureUnitSelected = (TempratureUnit.Celsius.rawValue,TempratureUnit.Celsius.description)
        }))
        
        alert.addAction(UIAlertAction(title: TempratureUnit.Fahrenheit.rawValue, style: .default , handler:{ (UIAlertAction)in
            controller.tempratureUnitSelected = (TempratureUnit.Fahrenheit.rawValue,TempratureUnit.Fahrenheit.description)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
          
        }))

        controller.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

