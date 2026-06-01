import Foundation
import Combine

class WeatherManager: ObservableObject {
    @Published var temperature: Double?
    @Published var humidity: Double?
    
    private let apiKey = APIKeys.cwaAPIKey
    private let stationId = "C0A520"
    init() {}
    
    func fetchWeather() {
        guard let url = URL(string: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/O-A0001-001?Authorization=\(apiKey)&StationId=\(stationId)") else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                do {
                    let decoded = try JSONDecoder().decode(CWAWeatherResponse.self, from: data)
                    if let station = decoded.records.Station.first {
                        if let temp = Double(station.WeatherElement.AirTemperature),
                           let hum = Double(station.WeatherElement.RelativeHumidity) {
                            DispatchQueue.main.async {
                                print("=== Weather Update ===")
                                print("Temperature:", temp)
                                print("Humidity:", hum)
                                self.temperature = temp
                                self.humidity = hum
                            }
                        }
                    }
                } catch {
                    print("Weather Decode Error:", error)
                }
            } catch {
                print("Weather API Error:", error)
            }
        }
    }
}
