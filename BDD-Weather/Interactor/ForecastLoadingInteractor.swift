//
//  ForecastLoadingInteractor.swift
//  BDD-Weather
//
//  Created by Gustavo Tiecker on 20/05/21.
//

import Foundation
import Combine

protocol ForecastProvider {
    func getForecasts() -> AnyPublisher<[Forecast], Error>
}

struct ForecastLoadingInteractor {
    var forecastProvider: ForecastProvider
}

extension ForecastLoadingInteractor {
    func perform(action: Action, in: AppState) -> AnyPublisher<[Forecast], Error> {
        forecastProvider
            .getForecasts()
            .map{ $0.sorted{ $0.cityName < $1.cityName } }
            .eraseToAnyPublisher()
    }
}

extension ForecastLoadingInteractor {
    enum Action {
        case load
    }
    enum Errors: Error {
        case unknown
    }
}
