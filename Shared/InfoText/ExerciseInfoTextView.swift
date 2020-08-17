//
//  ExerciseInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct ExerciseInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    
    var body: some View {
        HStack {
            Text("To meet your workout target you need to perform brisk activity for \(healthData.workoutMinsRemaining) more minutes before the end of the day. There's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day, plenty of time to smash that goal!")
                .font(.caption)
                .foregroundColor(Colors.yellowDark)
            Spacer()
        }
    }
}

struct ExerciseInfoTextView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseInfoTextView(healthData: HealthStoreManager())
    }
}
