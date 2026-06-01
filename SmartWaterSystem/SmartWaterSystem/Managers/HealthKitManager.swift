import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var steps: Int = 0
    @Published var heartRate: Double = 70.0
    @Published var weight: Double = 60.0
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        let typesToRead: Set = [stepType, heartRateType, weightType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                self.fetchTodaySteps()
                self.fetchLatestHeartRate()
                self.fetchLatestWeight()
            } else {
                print("HealthKit Authorization Failed")
            }
        }
    }
    
    func fetchTodaySteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                DispatchQueue.main.async { 
                    self.steps = 0 
                    print("=== HEALTHKIT FETCH FAILED ===")
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("No step data available")
                    }
                }
                return
            }
            
            let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self.steps = stepCount
                print("=== HEALTHKIT FETCH SUCCESS ===")
                print("Steps: \(self.steps)")
                print("HeartRate: \(self.heartRate)")
                print("Weight: \(self.weight)")
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchLatestHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                DispatchQueue.main.async { 
                    self.heartRate = 70.0 
                    print("=== HEALTHKIT FETCH FAILED ===")
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("No heart rate data available")
                    }
                }
                return
            }
            
            let heartRateUnit = HKUnit(from: "count/min")
            let bpm = sample.quantity.doubleValue(for: heartRateUnit)
            
            DispatchQueue.main.async {
                self.heartRate = bpm
                print("=== HEALTHKIT FETCH SUCCESS ===")
                print("Steps: \(self.steps)")
                print("HeartRate: \(self.heartRate)")
                print("Weight: \(self.weight)")
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchLatestWeight() {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                DispatchQueue.main.async { 
                    self.weight = 60.0 
                    print("=== HEALTHKIT FETCH FAILED ===")
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("No weight data available")
                    }
                }
                return
            }
            
            let weightUnit = HKUnit.gramUnit(with: .kilo)
            let kg = sample.quantity.doubleValue(for: weightUnit)
            
            DispatchQueue.main.async {
                self.weight = kg
                print("=== HEALTHKIT FETCH SUCCESS ===")
                print("Steps: \(self.steps)")
                print("HeartRate: \(self.heartRate)")
                print("Weight: \(self.weight)")
            }
        }
        
        healthStore.execute(query)
    }
}
