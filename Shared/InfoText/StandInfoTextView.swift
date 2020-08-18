//
//  StandInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct StandInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if healthData.standingHoursRemaining <= 0 {
            Text("You've met your stand target for today!")
                .font(.caption)
                .foregroundColor(Colors.blueDark)
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if healthData.standingHoursRemaining > 0 && healthData.standingHoursRemaining <= healthData.hoursAndMinsRemainingInDay.0 + 1 {
            HStack {
                Text("To meet your standing target you need to stand up and move around for at least a minute over \(healthData.standingHoursRemaining) more hours. It's still possible to hit this target as there's \(healthData.hoursAndMinsRemainingInDay.0)hr \(healthData.hoursAndMinsRemainingInDay.1)min remaining in the day.")
                    .font(.caption)
                    .foregroundColor(Colors.blueDark)
                Spacer()
            }
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Text("Sorry, you've run out of time to meet this target today ☹️")
                .font(.caption)
                .foregroundColor(Colors.blueDark)
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
        
        

    }
}

struct StandInfoTextView_Previews: PreviewProvider {
    static var previews: some View {
        StandInfoTextView(healthData: HealthStoreManager())
    }
}
