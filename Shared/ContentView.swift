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
    
    @State private var calsBurned = 356
    @State private var workoutMinutesAccrued = 23
    @State private var hoursStood = 8
    
    let calsTarget: Double = 500
    let workoutTargetMins = 30
    let standingTargetHours = 12
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Countdown").font(.largeTitle).bold().padding(.vertical)
            Text("Activity - cals remaining: \(calsTarget - healthData.calsBurned)")
            Text("Workout - mins remaining: \(workoutTargetMins - workoutMinutesAccrued)")
            Text("Standing - hours remaining: \(standingTargetHours - hoursStood)")
            Button("Update") { healthData.executeActivitySummaryQuery() }
        }
        .padding()
        .frame(width: 400, height: 300)
        .onAppear {
//            healthData.getActivity()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
