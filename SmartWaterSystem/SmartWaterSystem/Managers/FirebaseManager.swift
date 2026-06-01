import Foundation
import FirebaseDatabase
import Combine

class FirebaseManager: ObservableObject {
    
    private let ref: DatabaseReference = Database.database().reference()
    private let todayRef: DatabaseReference
    
    init() {
        self.todayRef = ref.child("health/today")
    }
    
    func syncAllData(steps: Int, heartRate: Double, weight: Double, temperature: Double, humidity: Double, targetWater: Double, completion: @escaping (Bool) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let readableTime = formatter.string(from: Date())
        
        let data: [String: Any] = [
            "steps": steps,
            "heartRate": heartRate,
            "weight": weight,
            "temperature": temperature,
            "humidity": humidity,
            "targetWater": targetWater,
            "timestamp": ServerValue.timestamp(),
            "lastSync": readableTime
        ]
        
        todayRef.updateChildValues(data) { error, _ in
            if let error = error {
                print("Firebase Upload Error:", error)
                DispatchQueue.main.async { completion(false) }
            } else {
                print("=== FIREBASE SYNC ===")
                DispatchQueue.main.async { completion(true) }
            }
        }
    }
}
