//
//  ContentView.swift
//  Shared
//
//  Created by Aidan Pendlebury on 15/07/2020.
//

/*
 TODO...
 - Round down the "remaining" values
 - Don't go into negative when target has been met (just show 543/500 for example)
 - Show bars for countdowns
 - Create widget
 */


import HealthKit
import SwiftUI

struct ContentView: View {
    
    // Pass this in as an ObservedObject later
    @StateObject var healthData = HealthStoreManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Countdown").font(.largeTitle).bold().padding(.vertical)

            Button("Update") { healthData.executeActivitySummaryQuery() }
            
            // Activity
            HStack {
                Capsule()
                    .fill(Gradients.activity)
                    .frame(width: 250, height: 20)
                if healthData.calsRemaining <= 0 {
                    SFSymbols.checkMark.foregroundColor(.green)
                } else {
                    Text("\(healthData.calsRemaining) cal")
                }
            }
            .frame(height: 20)
            
            // Exercise
            HStack {
                Capsule()
                    .fill(Gradients.exercise)
                    .frame(width: 250, height: 20)
                if healthData.workoutMinsRemaining <= 0 {
                    SFSymbols.checkMark.foregroundColor(.green)
                } else {
                    Text("\(healthData.workoutMinsRemaining) min")
                }
            }
            .frame(height: 20)
            
            // Standing
            HStack {
                Capsule()
                    .fill(Gradients.standing)
                    .frame(width: 250, height: 20)
                if healthData.standingHoursRemaining <= 0 {
                    SFSymbols.checkMark.foregroundColor(.green)
                } else {
                    Text("\(healthData.standingHoursRemaining) hr")
                }
            }
            .frame(height: 20)
                
        }
        .padding()
        .frame(width: 400, height: 300)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            healthData.executeActivitySummaryQuery()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                healthData.executeActivitySummaryQuery()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                healthData.executeActivitySummaryQuery()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
