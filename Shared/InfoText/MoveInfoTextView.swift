//
//  MoveInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct MoveInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    
    var body: some View {
        HStack {
            Group {
                Text("To hit your move goal by the end of the day you need to burn \(Int((calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1)).rounded(.up))) cals in the next \(healthData.hoursAndMinsRemainingInDay.1) mins")
                    + Text(healthData.hoursAndMinsRemainingInDay.0 >= 1 ? " and then an average of ~\((healthData.calsRemaining - Int(calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1))) / healthData.hoursAndMinsRemainingInDay.0) cal/hr over the remaining \(healthData.hoursAndMinsRemainingInDay.0) hours." : ".")
            }
            .font(.caption)
            .foregroundColor(Colors.pinkLight)
            Spacer()
        }
    }
    
    func calsPerMin() -> Double {
        let minsRemainingInDay = Double((healthData.hoursAndMinsRemainingInDay.0 * 60) + healthData.hoursAndMinsRemainingInDay.1)
        return Double(healthData.calsRemaining) / minsRemainingInDay
    }
}

struct MoveInfoTextView_Previews: PreviewProvider {
    static var previews: some View {
        MoveInfoTextView(healthData: HealthStoreManager())
    }
}
