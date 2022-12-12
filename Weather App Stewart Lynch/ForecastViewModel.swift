//
//  ForecastViewModel.swift
//  Weather App Stewart Lynch
//
//  Created by Baris Karalar on 11.12.22.
//

import Foundation

struct ForecastViewModel {
    let forecast: Forecast.Daily
    var system: Int
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double {
        let celcius = temp - 273.5
        if system == 0 {
            return celcius
        } else {
            return celcius * 9 / 5 + 32
        }
    }
    
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: °\(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")"
    }
    
    var low: String {
        return "L: °\(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")"
    }
    
    var pop: String {
        return "💧 \(Self.numberFormatter.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecast.humidity)%"
    }
    
    var weatherIconUrl: URL {
        URL(string: "https://openweathermap.org/img/wn/\(forecast.weather[0].icon).png")!
    }
    
}
