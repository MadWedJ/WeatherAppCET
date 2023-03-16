//
//  NetworkManager.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import Foundation

enum APIError: Error {
    case genericError
}

class NetworkManager {

    // %@ - плейсхолдер для типа стринг
    // При использование внутри String(format: ) на место плейсхолдера подставляется переданный аргумент типа стринг
    // Только String или краш
    // %d - Int плейсхолдер
    // %.2f - FLoat/Double плейсхолдер, число после . отвечает за количество знаков после запятой
    static let imageLinkTemplate = "https://openweathermap.org/img/wn/%@@2x.png"
    
    let link = "https://api.openweathermap.org/data/2.5/weather"
    let defaultQueryParameters: [URLQueryItem] = [
        URLQueryItem(name: "appid", value: "925a9e21a69ce7f0647e5c381ba3c331"),
        URLQueryItem(name: "units", value: "metric")
    ]
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: link) else {
            completion(.failure(APIError.genericError))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city)] + defaultQueryParameters
        guard let url = urlComponents.url else {
            completion(.failure(APIError.genericError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(APIError.genericError))
            }
        }
        
        task.resume()
    }
}
