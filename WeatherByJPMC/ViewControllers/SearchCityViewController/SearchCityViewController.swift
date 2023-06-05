//
//  SearchCityViewController.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import UIKit
import CoreLocation
import SwiftUI

class SearchCityViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
   
    private var data: Cities?
    //LocationBasedCityViewModel being re-used here because bussiness logic is same
    lazy var viewModel = {
        LocationBasedCityViewModel()
    }()
    private let tempratureUnitSelected : String
    
    //MARK: life cycle
    init?(coder: NSCoder, unit: String) {
        self.tempratureUnitSelected = unit
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.title = "Weather"
    }
}

//MARK: Private methods
extension SearchCityViewController {
    func searchCitiesWeather(text: String) {
        loadCities(text: text)
    }
    //API call for search city
    private func loadCities(text: String) {
        viewModel.loadCitiesFromServer(parameters: text) { [weak self] response in
            guard let response = response else {
                return
            }
            self?.data = response
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        } errorResponse: { [weak self] error  in
            self?.printAlertMessage(message: error?.localizedDescription ?? Constants.errorMessage, view: self ?? UIViewController())
        }
    }
}

//MARK: TableView datasource methods
extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detail = self.data?[indexPath.row] else {
            return
        }
        viewModel.navigateToDetailViewController(cityDetail: detail, unit: tempratureUnitSelected, navigationContoller: self.navigationController!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityWeatherTableViewCell", for: indexPath) as? SearchCityWeatherTableViewCell
        if let record = self.data?[indexPath.row] as? CityDetail{
            cell?.configureCell(record: record )
        }
        guard let cell = cell else {
            return UITableViewCell()
        }

        return cell
    }
}

//MARK: UISearchBarDelegate methods
extension SearchCityViewController: UISearchBarDelegate {
    //on change of search field method being called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            data = nil
            self.tableView.reloadData()
            return
        }
        loadCities(text: searchText)
    }
}
