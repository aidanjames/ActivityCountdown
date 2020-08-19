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
    @State private var showingMoveInfoText = false
    @State private var showingExerciseInfoText = false
    @State private var showingStandInfoText = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                ActivityProgressView(healthData: healthData, ringType: .activity, isRedacted: $isRedacted, showingMoveText: $showingMoveInfoText, showingExerciseText: $showingExerciseInfoText, showingStandText: $showingStandInfoText)
                if showingMoveInfoText { MoveInfoTextView(healthData: healthData) }
                ActivityProgressView(healthData: healthData, ringType: .exercise, isRedacted: $isRedacted, showingMoveText: $showingMoveInfoText, showingExerciseText: $showingExerciseInfoText, showingStandText: $showingStandInfoText)
                if showingExerciseInfoText { ExerciseInfoTextView(healthData: healthData) }
                
                ActivityProgressView(healthData: healthData, ringType: .standing, isRedacted: $isRedacted, showingMoveText: $showingMoveInfoText, showingExerciseText: $showingExerciseInfoText, showingStandText: $showingStandInfoText)
                if showingStandInfoText {
                    StandInfoTextView(healthData: healthData)
                }
            }
            Text("Time remaining in day: \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min").bold().padding(.bottom)

            Spacer() // Pushes everything to the top of the screen.
            
        }
        .padding(.horizontal)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            isRedacted = true
            showingMoveInfoText = false
            showingExerciseInfoText = false
            showingStandInfoText = false
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








