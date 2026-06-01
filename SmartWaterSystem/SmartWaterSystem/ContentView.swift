//
//  ContentView.swift
//  SmartWaterSystem
//
//  Created by Timothy on 2026/5/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                
                Image(systemName:  "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(vm.syncStatus.contains("Synced") ? .green : .blue)
                
                VStack(spacing: 16) {
                    Text("HealthKit & Weather Bridge")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(vm.syncStatus)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(vm.syncStatus.contains("Failed") ? .red : .primary)
                    
                    if let lastSync = vm.lastSyncTime {
                        Text("Last Sync: \(lastSync, formatter: timeFormatter)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                    .padding(.horizontal, 40)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .foregroundColor(.orange)
                        Text("Current Steps:")
                        Spacer()
                        Text("\(vm.healthKitManager.steps)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Heart Rate:")
                        Spacer()
                        Text(String(format: "%.0f bpm", vm.healthKitManager.heartRate))
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "scalemass.fill")
                            .foregroundColor(.purple)
                        Text("Weight:")
                        Spacer()
                        Text(String(format: "%.1f kg", vm.weight))
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(.orange)
                        Text("Temperature:")
                        Spacer()
                        if let temp = vm.weatherManager.temperature {
                            Text(String(format: "%.1f °C", temp))
                                .fontWeight(.semibold)
                        } else {
                            Text("-- °C")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "humidity.fill")
                            .foregroundColor(.blue)
                        Text("Humidity:")
                        Spacer()
                        if let hum = vm.weatherManager.humidity {
                            Text(String(format: "%.0f %%", hum))
                                .fontWeight(.semibold)
                        } else {
                            Text("-- %%")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.cyan)
                        Text("Target Water:")
                        Spacer()
                        Text(String(format: "%.0f ml", vm.targetWater))
                            .fontWeight(.semibold)
                    }
                }
                .font(.body)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("Data Bridge")
            .onAppear {
                vm.onAppear()
            }
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }
}

#Preview {
    ContentView()
}
