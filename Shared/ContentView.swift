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
            .padding(.top)
            VStack(alignment: .leading) {
                ActivityProgressView(healthData: healthData, ringType: .activity, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .exercise, isRedacted: $isRedacted)
                ActivityProgressView(healthData: healthData, ringType: .standing, isRedacted: $isRedacted)
            }
            .frame(height: 110)
            Text("Time remaining in day: \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min").bold().padding(.bottom)
            if healthData.calsRemaining > 0 {
                Group {
                    Text("To hit your move goal by the end of the day you need to burn \(Int((calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1)).rounded(.up))) cals in the next \(healthData.hoursAndMinsRemainingInDay.1) mins")
                        + Text(healthData.hoursAndMinsRemainingInDay.0 >= 1 ? " and then an average of ~\((healthData.calsRemaining - Int(calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1))) / healthData.hoursAndMinsRemainingInDay.0) cal/hr over the remaining \(healthData.hoursAndMinsRemainingInDay.0) hours." : ".")
                }
                .font(.caption)
                .foregroundColor(Colors.pinkLight)
                .padding(.bottom)

            }
            
            if healthData.workoutMinsRemaining > 0 && healthData.workoutMinsRemaining <= ((healthData.hoursAndMinsRemainingInDay.0 * 60) + healthData.hoursAndMinsRemainingInDay.1) {
                Text("To meet your workout target you need to perform brisk activity for \(healthData.workoutMinsRemaining) more minutes before the end of the day. There's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day, plenty of time to smash that goal!")
                    .font(.caption)
                    .foregroundColor(Colors.yellowDark)
                    .padding(.bottom)
            }
            
            
            if healthData.standingHoursRemaining > 0 && healthData.standingHoursRemaining <= healthData.hoursAndMinsRemainingInDay.0 + 1 {
                Text("To meet your standing target you need to stand up and move around for at least a minute over \(healthData.standingHoursRemaining) more hours. It's still possible to hit this target as there's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day.")
                    .font(.caption)
                    .foregroundColor(Colors.blueDark)
                    .padding(.bottom)
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
    
    func calsPerMin() -> Double {
        // cals remaining / number of mins remaining in day
        let minsRemainingInDay = Double((healthData.hoursAndMinsRemainingInDay.0 * 60) + healthData.hoursAndMinsRemainingInDay.1)
        return Double(healthData.calsRemaining) / minsRemainingInDay
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


