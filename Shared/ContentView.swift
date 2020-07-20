//
//  ContentView.swift
//  Shared
//
//  Created by Aidan Pendlebury on 15/07/2020.
//

import HealthKit
import SwiftUI

struct ContentView: View {
    
    // Pass this in as an ObservedObject later
    @StateObject var healthData = HealthStoreManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Countdown").font(.largeTitle).bold().padding(.vertical)
            Text("Activity - cals remaining: \(Int(healthData.calsTarget - healthData.calsBurned))")
            Text("Workout - mins remaining: \(Int(healthData.workoutTarget - healthData.minsWorkedOut))")
            Text("Standing - hours remaining: \(Int(healthData.standingTarget - healthData.hoursStood))")
            Button("Update") { healthData.executeActivitySummaryQuery() }
            
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [Colors.pinkDark, Colors.pinkLight]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 200, height: 10)
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [Colors.yellowDark, Colors.yellowLight]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 200, height: 10)
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [Colors.blueDark, Colors.blueLight]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 200, height: 10)
            
                
        }
        .padding()
        .frame(width: 400, height: 300)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            healthData.executeActivitySummaryQuery()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
