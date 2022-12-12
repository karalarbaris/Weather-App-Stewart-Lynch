//
//  ForecastListViewModel.swift
//  Weather App Stewart Lynch
//
//  Created by Baris Karalar on 12.12.22.
//

import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject {
    
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    @Published var forecasts: [ForecastViewModel] = []
    @Published var appError: AppError?
    @Published var isLoading: Bool = false
    
    @AppStorage("location") var location: String = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        if location != "" {
            getWeatherForecast()
        }
    }
    
    func getWeatherForecast() {
        
        if location == "" {
            forecasts = []
        } else {
            isLoading = true
            let apiService = APIServiceCombine.shared
            
            CLGeocoder().geocodeAddressString(location) { placemarks, error in
                
                if let error = error {
                    self.isLoading = false
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                    
                    apiService.getJSON(urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=d2ba5dfb7d4821a8e14a3fc0b41625f4", dateDecodingStrategy: .secondsSince1970) { (result:  Result<Forecast, APIServiceCombine.APIError>) in
                        
                        switch result {
                                
                            case .success(let forecast):
                                DispatchQueue.main.async {
                                    self.isLoading = false
                                    self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
                                }
                                
                                
                            case .failure(let apiError):
                                switch apiError {
                                    case .error(let errorString):
                                        self.isLoading = false
                                        self.appError = AppError(errorString: errorString)
                                }
                        }
                        
                        
                    }
                    
                }
            }
        }
    }
}
