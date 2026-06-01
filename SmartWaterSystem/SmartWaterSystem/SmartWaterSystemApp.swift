//
//  SmartWaterSystemApp.swift
//  SmartWaterSystem
//
//  Created by Timothy on 2026/5/30.
//

import SwiftUI
import FirebaseCore

@main
struct SmartWaterSystemApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
