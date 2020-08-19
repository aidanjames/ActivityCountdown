//
//  MoveInfoTextView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 11/08/2020.
//

import SwiftUI

struct MoveInfoTextView: View {
    @ObservedObject var healthData: HealthStoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if healthData.calsRemaining > 0 {
            
            HStack {
                Group {
                    Text("\(Int(healthData.calsBurned))/\(Int(healthData.calsTarget)) - To hit your move goal by the end of the day you need to burn \(Int((calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1)).rounded(.up))) cals in the next \(healthData.hoursAndMinsRemainingInDay.1) mins")
                        + Text(healthData.hoursAndMinsRemainingInDay.0 >= 1 ? " and then an average of ~\((healthData.calsRemaining - Int(calsPerMin() * Double(healthData.hoursAndMinsRemainingInDay.1))) / healthData.hoursAndMinsRemainingInDay.0) cal/hr over the remaining \(healthData.hoursAndMinsRemainingInDay.0) hours." : ".")
                }
                .font(.caption)
                .foregroundColor(Colors.pinkLight)
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
        } else {
            Text("You've met your move target today!")
                .font(.caption)
                .foregroundColor(Colors.pinkDark)
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
