//
//  WeatherBuilder.swift
//  HW_15
//
//  Created by Michael on 3/16/23.
//

import UIKit

struct WeatherBuilder {

    func build(weather: WeatherResponse) -> WeatherViewController {
        let controller = WeatherViewController()
        controller.weather = weather
        return controller
    }
}
