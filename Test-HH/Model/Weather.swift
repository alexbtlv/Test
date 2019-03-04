//
//  Weather.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/26/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let timezone: String
    let currently: Currently
    var date: String {
        let date = Date(timeIntervalSince1970: Double(currently.time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: date)
    }
}

struct Currently: Codable {
    let time: Int
    let summary: String
    let temperature: Double
    var temperatureC: Double {
        let tmp = (temperature - 32) / 1.8
        return round(100*tmp)/100
    }
}

