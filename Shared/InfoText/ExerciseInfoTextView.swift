//
//  ExerciseInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct ExerciseInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if healthData.workoutMinsRemaining <= 0 {
            Text("You've met your exercise target today!")
                .font(.caption)
                .foregroundColor(Colors.yellowDark)
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if healthData.workoutMinsRemaining > 0 && healthData.workoutMinsRemaining <= ((healthData.hoursAndMinsRemainingInDay.0 * 60) + healthData.hoursAndMinsRemainingInDay.1) {
            HStack {
                Text("\(Int(healthData.minsWorkedOut))/\(Int(healthData.workoutTarget)) - To meet your workout target you need to perform brisk activity for \(healthData.workoutMinsRemaining) more minutes before the end of the day. There's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day, plenty of time to smash that goal!")
                    .font(.caption)
                    .foregroundColor(Colors.yellowDark)
                Spacer()
            }
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Text("Sorry, you've run out of time to meet this target today ☹️")
                .font(.caption)
                .foregroundColor(Colors.yellowDark)
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
        

    }
}

struct ExerciseInfoTextView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseInfoTextView(healthData: HealthStoreManager())
    }
}
