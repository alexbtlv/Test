//
//  Weather.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/26/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct Weather {
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

struct Currently {
    let time: Int
    let summary: String
    let temperature: Double
}

extension Weather: Decodable,  Encodable  {
    enum WeatherCodingKeys: String, CodingKey {
        case timezone
        case currently
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherCodingKeys.self)
        
        timezone = try container.decode(String.self, forKey: .timezone)
        currently = try container.decode(Currently.self, forKey: .currently)
    }
}

extension Currently: Decodable, Encodable {
    enum CurrentlyCodingKeys: String, CodingKey {
        case time
        case summary
        case temperature
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentlyCodingKeys.self)
        
        time = try container.decode(Int.self, forKey: .time)
        summary = try container.decode(String.self, forKey: .summary)
        temperature = try container.decode(Double.self, forKey: .temperature)
    }
}
