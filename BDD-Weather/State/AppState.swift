//
//  AppState.swift
//  BDD-Weather
//
//  Created by Gustavo Tiecker on 20/05/21.
//

import Foundation

final class AppState {
    
    enum Status {
        case loadingForecast
        case loadedForecasts
    }
    var status: Status
    var forecasts: [Forecast]
    
    init(status: Status, forecasts: [Forecast] = []) {
        self.status = status
        self.forecasts = forecasts
    }
}
