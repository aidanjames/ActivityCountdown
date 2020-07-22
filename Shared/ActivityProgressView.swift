//
//  ProgressView.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 22/07/2020.
//

import SwiftUI

struct ActivityProgressView: View {
    
    @ObservedObject var healthData: HealthStoreManager
    let ringType: RingType
    
    var remaining: Int {
        switch ringType {
        case .activity:
            return healthData.calsRemaining
        case .exercise:
            return healthData.workoutMinsRemaining
        case .standing:
            return healthData.standingHoursRemaining
        }
    }
    
    var ringColour: LinearGradient {
        switch ringType {
        case .activity:
            return Gradients.activity
        case .exercise:
            return Gradients.exercise
        case .standing:
            return Gradients.standing
        }
    }
    
    var metric: String {
        switch ringType {
        case .activity:
            return "cal"
        case .exercise:
            return "min"
        case .standing:
            return "hr"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Capsule()
                    .fill(ringColour)
                    .frame(width: geo.size.width * 0.8, height: 20)
                if remaining <= 0 {
                    SFSymbols.checkMark.foregroundColor(.green)
                } else {
                    Text("\(remaining) \(metric)")
                }
            }
            
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .activity)
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .exercise)
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .standing)
        }
    }
}
