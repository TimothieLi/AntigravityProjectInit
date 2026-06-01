import Foundation

class WaterCalculator {
    static func calculateTargetWater(weight: Double, temperature: Double, humidity: Double, heartRate: Double, steps: Int) -> Double {
        var targetWater = weight * 35.0
        
        let extraFromSteps = Double(steps / 1000) * 100.0
        targetWater += extraFromSteps
        
        if temperature >= 30.0 {
            targetWater += 300.0
        }
        if temperature >= 35.0 {
            targetWater += 300.0
        }
        
        if humidity >= 80.0 {
            targetWater += 200.0
        }
        
        if heartRate >= 100.0 {
            targetWater += 300.0
        }
        if heartRate >= 120.0 {
            targetWater += 300.0
        }
        
        return targetWater
    }
}
