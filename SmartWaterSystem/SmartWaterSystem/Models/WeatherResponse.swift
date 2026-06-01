import Foundation

struct CWAWeatherResponse: Codable {
    let records: CWARecords
}

struct CWARecords: Codable {
    let Station: [CWAStation]
}

struct CWAStation: Codable {
    let StationId: String
    let WeatherElement: CWAWeatherElement
}

struct CWAWeatherElement: Codable {
    let AirTemperature: String
    let RelativeHumidity: String
}
