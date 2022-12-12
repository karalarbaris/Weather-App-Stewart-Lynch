//
//  Forecast.swift
//  Weather App Stewart Lynch
//
//  Created by Baris Karalar on 07.12.22.
//

import Foundation

struct Forecast: Codable {
    
    struct Daily: Codable {
        let dt: Date
        
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
        }
        
        let weather: [Weather]
        let clouds: Int
        let pop: Double
        
    }
    
    let daily: [Daily]
    
}
