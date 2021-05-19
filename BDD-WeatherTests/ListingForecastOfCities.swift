//
//  ListingForecastOfCities.swift
//  BDD-WeatherTests
//
//  Created by Gustavo Tiecker on 19/05/21.
//

import Foundation
import Quick
import Nimble
@testable import BDD_Weather

final class ListingForecastOfCities: QuickSpec {
    override func spec() {
        
        describe("Listing forecast of cities") {
            
            context("""
                    GIVEN   the target cities are San Francisco (SFO) and Porto Alegre (POA)
                    AND     in SFO, it is 20º, "Sunny", with a min-max of 15º and 25º
                    AND     in POA, it is 15º, "Cloudy", with a min-max of 10º and 20º
                    AND     the App has started to load the forecast for the target cities
                    """) {
                        
                        context("""
                                WHEN    loading finishes successfully
                                """) {
                                    
                                    it( """
                                        THEN    there should be two cities loaded, SFO and POA
                                        AND     the cities should be in alphabetic order
                                        AND     it should be 15º, "Cloudy", with a min-max of 10º and 20º
                                        AND     it should be 20º, "Sunny", with a min-max of 15º and 25º
                                        """) {

                                    }
                        }
            }
        }
    }
}
