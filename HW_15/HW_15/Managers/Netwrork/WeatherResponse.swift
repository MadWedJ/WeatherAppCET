//
//  WeatherResponse.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import Foundation

struct WeatherResponse: Codable {
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let base: String
    let visibility: Int
    let dt: Int
    let coord: Coordinates
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let sys: System

    var iconUrl: String {
        String(format: NetworkManager.imageLinkTemplate, weather[0].icon)
    }

    var weatherInfoData: [WeatherInfoType] {
        return [
            .visibility("\(visibility) m"),
            .pressure("\(main.pressure) hPa"),
            .humidity("\(main.humidity)%"),
            .feelsLike(String(format: "%.1f°C", main.feels_like)),
            .tempMin(String(format: "%.1f°C", main.temp_min)),
            .tempMax(String(format: "%.1f°C", main.temp_max)),
            .windSpeed(String(format: "%.1f m/s", wind.speed)),
            .windDegree(windDegreeToString)
        ]
    }

    private var windDegreeToString: String {
        let degree = wind.deg
        if (degree >= 0 && degree <= 10) || (degree >= 350 && degree <= 360) {
            return "N"
        } else if degree <= 30 {
            return "N/NE"
        } else if degree <= 50 {
            return "NE"
        } else if degree <= 70 {
            return "E/NE"
        } else if degree <= 100 {
            return "N"
        } else if degree <= 120 {
            return "E/SE"
        } else if degree <= 140 {
            return "SE"
        } else if degree <= 160 {
            return "S/SE"
        } else if degree <= 190 {
            return "S"
        } else if degree <= 210 {
            return "W/SW"
        } else if degree <= 230 {
            return "SW"
        } else if degree <= 250 {
            return "W/SW"
        } else if degree <= 280 {
            return "W"
        } else if degree <= 300 {
            return "W/NW"
        } else if degree <= 320 {
            return "NW"
        } else {
            return "N/NW"
        }
    }
    
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct System: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}
