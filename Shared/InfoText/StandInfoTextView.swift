//
//  StandInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct StandInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    
    var body: some View {
        HStack {
            Text("To meet your standing target you need to stand up and move around for at least a minute over \(healthData.standingHoursRemaining) more hours. It's still possible to hit this target as there's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day.")
                .font(.caption)
                .foregroundColor(Colors.blueDark)
            Spacer()
        }
    }
}

struct StandInfoTextView_Previews: PreviewProvider {
    static var previews: some View {
        StandInfoTextView(healthData: HealthStoreManager())
    }
}
