//
//  DatabaseManager.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import Foundation
import RealmSwift

class DatabaseManager {
    let realm = try! Realm()

    func saveWeather(name: String, id: Int) {
        if let weather = realm.object(ofType: WeatherRealmModel.self, forPrimaryKey: id) {
            // UPDATE
            try! realm.write {
                weather.name = name
            }
        } else {
            // CREATE
            let weather = WeatherRealmModel(name: name, id: id)
            try! realm.write {
                realm.add(weather)
            }
        }
    }

    func deleteWeather(id: Int) {
        if let weather = realm.object(ofType: WeatherRealmModel.self, forPrimaryKey: id) {
            // DELETE
            try! realm.write {
                realm.delete(weather)
            }
        }
    }

    func isWeatherInFavorite(id: Int) -> Bool {
        //READ
        realm.object(ofType: WeatherRealmModel.self, forPrimaryKey: id) != nil
    }

    func getSavedWeather() -> [WeatherNameAndId] {
        //READ
        realm.objects(WeatherRealmModel.self).map { WeatherNameAndId(model: $0) }
    }
}
