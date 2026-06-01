import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    
    // Dependencies
    @Published var healthKitManager = HealthKitManager()
    @Published var weatherManager = WeatherManager()
    @Published var firebaseManager = FirebaseManager()
    
    @Published var syncStatus: String = "Waiting..."
    @Published var lastSyncTime: Date?
    
    @Published var weight: Double = 60.0
    @Published var targetWater: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var healthTimer: AnyCancellable?
    private var weatherTimer: AnyCancellable?
    
    init() {
        setupBindings()
        
        healthTimer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshHealthData()
            }
            
        weatherTimer = Timer.publish(every: 600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshWeatherData()
            }
    }
    
    func onAppear() {
        healthKitManager.requestAuthorization()
        refreshWeatherData()
    }
    
    func refreshHealthData() {
        print("=== HEALTH TIMER FIRED ===")
        healthKitManager.fetchTodaySteps()
        healthKitManager.fetchLatestHeartRate()
        healthKitManager.fetchLatestWeight()
    }
    
    func refreshWeatherData() {
        print("=== WEATHER TIMER FIRED ===")
        weatherManager.fetchWeather()
    }
    
    private func setupBindings() {
        // Observe HealthKit metrics
        Publishers.CombineLatest3(
            healthKitManager.$steps,
            healthKitManager.$heartRate,
            healthKitManager.$weight
        )
        // Removed filter so it can sync default values when data is missing
        .debounce(for: .seconds(2), scheduler: RunLoop.main)
        .sink { [weak self] steps, heartRate, weight in
            print("=== HEALTHKIT UPDATE ===")
            print("Steps: \(steps)")
            print("HeartRate: \(Int(heartRate))")
            print("Weight: \(weight)")
            self?.weight = weight
            self?.recalculateAndSyncWater()
        }
        .store(in: &cancellables)
        
        // Observe Weather metrics
        Publishers.CombineLatest(
            weatherManager.$temperature,
            weatherManager.$humidity
        )
        .compactMap { temp, hum -> (Double, Double)? in
            guard let t = temp, let h = hum else { return nil }
            return (t, h)
        }
        .sink { [weak self] temp, hum in
            print("=== WEATHER UPDATE ===")
            print("Temperature: \(temp)")
            print("Humidity: \(hum)")
            self?.recalculateAndSyncWater()
        }
        .store(in: &cancellables)
    }
    
    private func recalculateAndSyncWater() {
        let steps = healthKitManager.steps
        let heartRate = healthKitManager.heartRate
        let weight = healthKitManager.weight
        let temp = weatherManager.temperature ?? 25.0 // Fallback if weather not yet ready
        let hum = weatherManager.humidity ?? 50.0 // Fallback if weather not yet ready
        
        self.targetWater = WaterCalculator.calculateTargetWater(weight: weight, temperature: temp, humidity: hum, heartRate: heartRate, steps: steps)
        
        print("""
        === WATER CALCULATION ===
        Target Water: \(Int(targetWater)) ml
        """)
        
        self.syncStatus = "Syncing..."
        
        firebaseManager.syncAllData(steps: steps, heartRate: heartRate, weight: weight, temperature: temp, humidity: hum, targetWater: targetWater) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.syncStatus = "Synced"
                self.lastSyncTime = Date()
            } else {
                self.syncStatus = "Sync Failed"
            }
        }
    }
}
