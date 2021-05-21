//
//  ContentView.swift
//  BDD-Weather
//
//  Created by Gustavo Tiecker on 19/05/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    private let forecasts: [Forecast] = [
        Forecast(cityName: "San Francisco", currentForecast: "Sunny", currentTemp: 20.0, minTemp: 15.0, maxTemp: 25.0),
        Forecast(cityName: "Porto Alegre", currentForecast: "Cloudy", currentTemp: 15.0, minTemp: 10.0, maxTemp: 20.0)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<forecasts.count) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(self.forecasts[index].cityName) - \(Int(self.forecasts[index].currentTemp.rounded()))º")
                                .font(.system(size: 17))
                                .foregroundColor(Color.black)
                            Text("\(Int(self.forecasts[index].minTemp.rounded()))º - \(Int(self.forecasts[index].maxTemp))º")
                                .font(.system(size: 15))
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                        Image(systemName: self.forecasts[index].currentForecast == "Sunny" ? "sun.max.fill" : "cloud.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38, alignment: .center)
                    }
                }
            }.navigationBarTitle("Forecasts")
        }
    }
}

extension Forecast: Identifiable {
    var id: String { return cityName }
}
