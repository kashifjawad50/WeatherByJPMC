//
//  CityWeatherDetailViewController.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import UIKit
import CoreLocation
import MBProgressHUD
import SDWebImage

class CityWeatherDetailViewController: UIViewController {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var tempratureLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    
    var cityDetail: CityDetail
    let temperatureUnit: String
    lazy var viewModel = {
        CityWeatherDetailViewModel()
    }()
    weak var locationManager: LocationManager?
    
    //MARK: life cycle
    init?(coder: NSCoder, cityDetail: CityDetail, unit: String) {
        self.cityDetail = cityDetail
        self.temperatureUnit = unit
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSelectedLocationWeather()
        self.cityNameLabel.text = cityDetail.name
    }
}

//MARK: private methods
private extension CityWeatherDetailViewController {
    func loadSelectedLocationWeather() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.loadSelectedCityWeatherFromServer(cityName: cityDetail.name, unit: self.temperatureUnit) { [weak self] weatherData in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                
                guard let weatherData = weatherData else {
                    return
                }
                self?.settingDataToUI(weatherData: weatherData)
           }
        } errorResponse: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func settingDataToUI(weatherData: WeatherData) {
        self.tempratureLabel.text = "\(Int(weatherData.main.temp))°"
        self.downloadIcon(icon: weatherData.weather[0].icon)
    }
    
    func downloadIcon(icon: String) {
        self.weatherImage.sd_setImage(with: URL(string:  (Constants.baseURLDownloadIcon + icon + Constants.imageExtension).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), completed: nil)
    }
}

