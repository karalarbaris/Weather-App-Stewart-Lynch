//
//  ContentView.swift
//  Weather App Stewart Lynch
//
//  Created by Baris Karalar on 07.12.22.
//

import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {
    
    @StateObject private var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Picker(selection: $forecastListVM.system, label: Text("System")) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width:100)
                    .padding(.vertical)
                    
                    HStack {
                        TextField("Enter location", text: $forecastListVM.location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay (alignment: .trailing) {
                                Button {
                                    forecastListVM.location = ""
                                    forecastListVM.getWeatherForecast()
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                        
                        Button {
                            forecastListVM.getWeatherForecast()
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title3)
                        }
                        
                    }
                    
                    List(forecastListVM.forecasts, id: \.day) { day in
                        VStack(alignment: .leading) {
                            Text(day.day)
                                .fontWeight(.bold)
                            HStack(alignment: .center) {
                                WebImage(url: day.weatherIconUrl)
                                    .resizable()
                                    .placeholder(Image(systemName: "hourglass"))
                                    .scaledToFit()
                                    .frame(width: 75)
                                //                            Image(systemName: "hourglass")
                                //                                .font(.title)
                                //                                .frame(width: 50, height: 50)
                                //                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.green ))
                                VStack(alignment: .leading) {
                                    Text(day.overview)
                                    HStack {
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                    HStack {
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }
                                    Text(day.humidity)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding(.horizontal)
                .navigationTitle("Weather App")
                .alert(item: $forecastListVM.appError) { appAlert in
                    Alert(title: Text("Error"), message: Text("\(appAlert.errorString)\nPlease try again!!!!!"))
                }
            }
            if forecastListVM.isLoading {
                ZStack {
                    Color(.white)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Fetching")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: 10)

                }
            }
        }
        
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
