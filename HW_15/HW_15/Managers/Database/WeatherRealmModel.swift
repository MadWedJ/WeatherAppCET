//
//  WeatherRealmModel.swift
//  HW_15
//
//  Created by Michael on 3/2/23.
//

import Foundation
import RealmSwift

class WeatherRealmModel: Object {
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var name: String = ""
    convenience init(name: String, id: Int) {
        self.init()
        _id = id
        self.name = name
    }
}

struct WeatherNameAndId {
    let id: Int
    let name: String

    init(model: WeatherRealmModel) {
        id = model._id
        name = model.name
    }
}
