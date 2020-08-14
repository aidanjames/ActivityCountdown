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
    @State private var isRedacted = true
    @Environment(\.colorScheme) var colorScheme
    
    // Help text variables
    @State private var showingMoveInfoText = true
    @State private var showingExerciseInfoText = true
    @State private var showingStandInfoText = true
    
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
            .padding(.top)
            VStack(alignment: .leading) {
                ActivityProgressView(healthData: healthData, ringType: .activity, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .exercise, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .standing, isRedacted: $isRedacted)
            }
            .frame(height: 110)
            Text("Time remaining in day: \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min").bold().padding(.bottom)
           
            if showingMoveInfoText {
                if healthData.calsRemaining > 0 {
                    MoveInfoTextView(healthData: healthData)
                        .padding()
                        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("You've met your target today!")
                }
            }

            if showingExerciseInfoText {
                if healthData.workoutMinsRemaining <= 0 {
                    Text("You've met your target today!")
                } else if healthData.workoutMinsRemaining > 0 && healthData.workoutMinsRemaining <= ((healthData.hoursAndMinsRemainingInDay.0 * 60) + healthData.hoursAndMinsRemainingInDay.1) {
                    ExerciseInfoTextView(healthData: healthData)
                        .padding()
                        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("Sorry, you've run out of time to meet this target today ☹️")
                }
            }

            
            if showingStandInfoText {
                if healthData.standingHoursRemaining <= 0 {
                    Text("You've met your target for today!")
                } else if healthData.standingHoursRemaining > 0 && healthData.standingHoursRemaining <= healthData.hoursAndMinsRemainingInDay.0 + 1 {
                    StandInfoTextView(healthData: healthData)
                        .padding()
                        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("Sorry, you've run out of time to meet this target today ☹️")
                }
            }

            
            
            
            
            Spacer()
            
        }
        .padding(.horizontal)
        //        .frame(height: 400)
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








