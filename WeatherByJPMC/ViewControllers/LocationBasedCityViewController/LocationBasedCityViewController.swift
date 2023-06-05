//
//  LocationBasedCityViewController.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/4/23.
//


import UIKit
import CoreLocation
import MBProgressHUD
import SDWebImage

class LocationBasedCityViewController: UIViewController {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var tempratureLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    
    private lazy var viewModel = {
        CityWeatherDetailViewModel()
    }()
    weak var locationManager: LocationManager?
    //a tuple to hold enum selected status
    var tempratureUnitSelected = (TempratureUnit.Fahrenheit.rawValue,TempratureUnit.Fahrenheit.description) {
        didSet {
            navigationItem.leftBarButtonItem?.title = tempratureUnitSelected.0
            LocationManager.sharedInstance.startUpdatingLocation()
        }
    }
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        setupNavigation()
    }
}

//MARK: private methods
private extension LocationBasedCityViewController {
    func loadSelectedLocationWeather(name: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        viewModel.loadSelectedCityWeatherFromServer(cityName: name, unit: self.tempratureUnitSelected.1) { [weak self] weatherData in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                
                guard let weatherData = weatherData else {
                    return
                }
                self?.settingDataToUI(weatherData: weatherData)
           }
        } errorResponse: { [weak self] error  in
            MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            self?.printAlertMessage(message: error?.localizedDescription ?? Constants.errorMessage, view: self ?? UIViewController())
        }
    }
    
    func settingDataToUI(weatherData: WeatherData) {
        self.tempratureLabel.text = "\(Int(weatherData.main.temp))°"
        self.downloadIcon(icon: weatherData.weather[0].icon)
    }
    
    func downloadIcon(icon: String) {
        self.weatherImage.sd_setImage(with: URL(string:  (Constants.baseURLDownloadIcon + icon + Constants.imageExtension).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), completed: nil)
    }
    
    func locationSetup() {
        locationManager = LocationManager.sharedInstance
        LocationManager.sharedInstance.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("locationInformation"), object: nil)
    }
    
    func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search City", style: .plain, target: self, action: #selector(searchCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: tempratureUnitSelected.0, style: .plain, target: self, action: #selector(tempratureTypeTapped))
    }
    
    @objc func tempratureTypeTapped()  {
        viewModel.changeTempratureUnit(controller: self)
    }
    
    
    @objc func searchCity()  {
        viewModel.navigateToSearch(navigationContoller: self.navigationController!, unit: self.tempratureUnitSelected.1)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        guard let city = locationManager?.locationInformation.value(forKey: "city") as? String else {
            return
        }
        loadSelectedLocationWeather(name: city)
        self.cityNameLabel.text = city
    }
    
    //MARK: can be used to download Icon through URSession
    func downloadImgeByCode(icon: String) {
        guard let request = WeatherIconDownloadRequest.makeRequest(parameters: icon) else{
            return
        }
        NetworkingServices.load(request: request) { iconData in
            if let data = iconData {
                DispatchQueue.main.async {
                    self.weatherImage.image = UIImage(data: data)
                    
                }
            }
        } fail: { [weak self] error  in
            self?.printAlertMessage(message: error?.localizedDescription ?? Constants.errorMessage, view: self ?? UIViewController())
        }
    }
}


