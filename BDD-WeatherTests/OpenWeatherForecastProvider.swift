//
//  OpenWeatherForecastProvider.swift
//  BDD-WeatherTests
//
//  Created by Gustavo Tiecker on 20/05/21.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import BDD_Weather

final class OpenWeatherForecastProviderTests: QuickSpec {
    
    override func spec() {
        describe("OpenWeatherForecastProvider") {
            context("performing a successfull request") {
                it("should decode Forecast objects apropriately") {
                    // Arrange
                    let apiKey = "5a1cc0aef804e4d1b2f844ee7c6e7b7b"
                    let cityName = "London"
                    let sessionProvider = MockSessionProvider()
                    let provider: ForecastProvider = OpenWeatherForecastProvider(sessionProvider: sessionProvider,
                                                                                 apiKey: apiKey,
                                                                                 cityNames: [cityName])
                    var forecasts: [Forecast] = []
                    
                    // Act
                    _ = provider
                        .getForecasts()
                        .sink(receiveCompletion: {
                            if case .failure(let error) = $0 {
                                fail("Op should not fail \(error)")
                            }
                        }) { forecasts = $0 }
                        
                    // Assert
                    let expectedForecast = Forecast(cityName: "London", currentForecast: "Drizzle", currentTemp: 7.17, minTemp: 6.00, maxTemp: 8.00)
                    expect(forecasts).toEventually(equal([expectedForecast]))
                }
            }
        }
        
        
    }
}

protocol SessionProvider{
    func data(for url: URL) -> AnyPublisher<Data, Error>
}

struct OpenWeatherForecastProvider {
    var sessionProvider: SessionProvider = URLSession.shared
    var apiKey: String
    var cityNames: [String]
}

extension URLSession: SessionProvider {
    func data(for url: URL) -> AnyPublisher<Data, Error> {
        dataTaskPublisher(for: url)
            .map{ $0.data }
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
    }
}

extension Forecast {
    init(_ response: OpenWeatherForecastProvider.Response) {
        self.cityName = response.name ?? "No Name"
        self.currentForecast =  response.weather?.first?.main ?? "No Temp"
        self.currentTemp = (response.main?.temp ?? 0.0) - 273.15
        self.minTemp = (response.main?.tempMin ?? 0.0) - 273.15
        self.maxTemp = (response.main?.tempMax ?? 0.0) - 273.15
    }
}

extension OpenWeatherForecastProvider: ForecastProvider {
    
    func getForecasts() -> AnyPublisher<[Forecast], Error> {
        if cityNames.isEmpty {
            Fail<[Forecast], Error>(error: Self.Errors.unknow).eraseToAnyPublisher()
        }
        return _getForecasts()
    }
    
    private func _getForecasts(at index: Int = 0) -> AnyPublisher<[Forecast], Error> {
        let baseURLString = "https://api.openweathermap.org/data/2.5/weather"
        guard var components = URLComponents(string: baseURLString) else { fatalError() }
        components.queryItems = [URLQueryItem(name: "q", value: cityNames[index]),
                                 URLQueryItem(name: "appid", value: apiKey)]
        guard let url = components.url else { fatalError() }
        
        let publisherAtIndex = sessionProvider
            .data(for: url)
            .decode(type: Response.self, decoder: JSONDecoder())
            .map{ [Forecast($0)] }
            .eraseToAnyPublisher()
        
        if index + 1 == cityNames.count {
            return publisherAtIndex
        } else {
            return publisherAtIndex
                .combineLatest(self._getForecasts(at: index + 1)) { $0 + $1 }
                .eraseToAnyPublisher()
        }
    }
    
    struct Response: Codable {
        struct Weather: Codable {
            let main: String
        }
        var weather: [Weather]?
        struct Main: Codable {
            var temp: Double?
            var tempMin: Double?
            var tempMax: Double?
            
            enum CodingKeys: String, CodingKey {
                case temp
                case tempMin = "temp_min"
                case tempMax = "temp_max"
            }
        }
        var main: Main?
        var name: String?
    }
    
    enum Errors: Error {
        case unknow
    }
}

struct MockSessionProvider: SessionProvider {
    
    func data(for url: URL) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { $0(.success(self.sampleResponse.data(using: .utf8)!)) }.eraseToAnyPublisher()
    }
    
    private let sampleResponse = "{\"coord\":{\"lon\":-0.13,\"lat\":51.51},\"weather\":[{\"id\":300,\"main\":\"Drizzle\",\"description\":\"light intensity drizzle\",\"icon\":\"09d\"}],\"base\":\"stations\",\"main\":{\"temp\":280.32,\"pressure\":1012,\"humidity\":81,\"temp_min\":279.15,\"temp_max\":281.15},\"visibility\":10000,\"wind\":{\"speed\":4.1,\"deg\":80},\"clouds\":{\"all\":90},\"dt\":1485789600,\"sys\":{\"type\":1,\"id\":5091,\"message\":0.0103,\"country\":\"GB\",\"sunrise\":1485762037,\"sunset\":1485794875},\"id\":2643743,\"name\":\"London\",\"cod\":200}"
}
