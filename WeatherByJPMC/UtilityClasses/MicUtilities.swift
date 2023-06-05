//
//  AlertUtility.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    func printAlertMessage(message:String,view:UIViewController) {
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in

            return
        }
        alertController.addAction(okAction)
            view.present(alertController, animated: true, completion: nil)
        }
        
    }
}

enum TempratureUnit: String, CustomStringConvertible {
  case Fahrenheit, Celsius

  var description: String {
    get {
      switch self {
        case .Fahrenheit:
          return "imperial"
        case .Celsius:
          return "metric"
      }
    }
  }
}
