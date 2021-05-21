//
//  Forecast.swift
//  BDD-Weather
//
//  Created by Gustavo Tiecker on 20/05/21.
//

import Foundation

struct Forecast: Equatable {
    var cityName: String
    var currentForecast: String
    var currentTemp: Double
    var minTemp: Double
    var maxTemp: Double
}

extension Forecast {
    static func ==(lhs: Forecast, rhs: Forecast) -> Bool {
        return lhs.cityName == rhs.cityName
            && lhs.currentForecast == rhs.currentForecast
            && Int(lhs.currentTemp*100) == Int(rhs.currentTemp*100)
            && Int(lhs.minTemp*100) == Int(rhs.minTemp*100)
            && Int(lhs.maxTemp*100) == Int(rhs.maxTemp*100)
    }
}
