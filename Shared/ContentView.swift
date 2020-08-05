//
//  ContentView.swift
//  Shared
//
//  Created by Aidan Pendlebury on 15/07/2020.
//

/*
 TODO...
 - Show bars for countdowns
 - Create widget
 */


import HealthKit
import SwiftUI

struct ContentView: View {
    
    // Pass this in as an ObservedObject later
    @StateObject var healthData = HealthStoreManager()
    @State private var isRedacted = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Activity Countdown").font(.largeTitle).bold()
                Spacer()
                Button(action: { healthData.executeActivitySummaryQuery() }, label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                        .padding(.trailing)
                })
            }
            
            VStack(alignment: .leading) {
                ActivityProgressView(healthData: healthData, ringType: .activity, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .exercise, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .standing, isRedacted: $isRedacted)
            }
            if healthData.standingHoursRemaining <= healthData.hoursRemainingInDay && healthData.standingHoursRemaining != 0 {
                Text("Hours remaining: \(healthData.hoursRemainingInDay)")
            }
            if healthData.calsRemaining > 0 {
                Text("You need to burn \(healthData.calsRemaining / healthData.hoursRemainingInDay) cals an hour over the next \(healthData.hoursRemainingInDay) hours to meet your cal goal.")
            }
            
            Spacer()

        }
        .padding(.horizontal)
        .frame(height: 300)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            isRedacted = true
            healthData.executeActivitySummaryQuery()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                healthData.executeActivitySummaryQuery()
                if healthData.calsTarget != 1000 {
                    isRedacted = false
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                healthData.executeActivitySummaryQuery()
                if healthData.calsTarget != 1000 {
                    isRedacted = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


