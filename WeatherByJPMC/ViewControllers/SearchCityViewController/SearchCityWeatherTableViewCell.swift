//
//  SearchWeatherTableViewCell.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import UIKit

class SearchCityWeatherTableViewCell: UITableViewCell {
    @IBOutlet private weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
     func configureCell(record: CityDetail) {
         self.cityLabel.text = record.name + ", " + record.state + ", " + record.country
    }

}
