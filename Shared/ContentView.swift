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
        }
        .padding()
        .frame(width: 400, height: 300)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
