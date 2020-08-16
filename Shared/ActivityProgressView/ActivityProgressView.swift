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
    let height: CGFloat = 20
    @Binding var isRedacted: Bool
    @Binding var showingMoveText: Bool
    @Binding var showingExerciseText: Bool
    @Binding var showingStandText: Bool
    
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
    
    var progress: CGFloat {
        switch ringType {
        case .activity:
            guard healthData.calsBurned < healthData.calsTarget else { return 1 }
            return CGFloat(healthData.calsBurned / healthData.calsTarget)
        case .exercise:
            guard healthData.minsWorkedOut < healthData.workoutTarget else { return 1 }
            return CGFloat(healthData.minsWorkedOut / healthData.workoutTarget)
        case .standing:
            guard healthData.hoursStood < healthData.standingTarget else { return 1 }
            return CGFloat(healthData.hoursStood / healthData.standingTarget)
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
    
    var checkColour: Color {
        switch ringType {
        case .activity:
            return Colors.pinkDark
        case .exercise:
            return Colors.yellowDark
        case .standing:
            return Colors.blueDark
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
            let barWidth = geo.size.width * 0.75
            
            HStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    BarView(valueRemaining: remaining, target: Int(healthData.calsTarget), width: barWidth, height: height, colour: ringColour)
                        .opacity(0.2)
                    BarView(valueRemaining: remaining, target: Int(healthData.calsTarget), width: progress * barWidth, height: height, colour: ringColour)
                }.frame(width: barWidth)
                if remaining <= 0 {
                    SFSymbols.checkMark.foregroundColor(checkColour)
                        .frame(width: geo.size.width * 0.2, height: height)
                } else {
                    Text("\(remaining) \(metric)")
                        .frame(width: geo.size.width * 0.2, height: height)
                        .redacted(reason: isRedacted ? .placeholder : .init())
                }
                
                Button(action: {
                    switch ringType {
                    case .activity:
                        withAnimation {
                            showingMoveText.toggle()
                        }
                    case .exercise:
                        withAnimation {
                            showingExerciseText.toggle()
                        }
                    case .standing:
                        withAnimation {
                            showingStandText.toggle()
                        }
                    }
                } ) {
                    SFSymbols.info
                }
                
                Spacer()
            }
        }
        .frame(height: height)
        .padding(.vertical, 10)
    }
    
    
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .activity, isRedacted: .constant(true), showingMoveText: .constant(true), showingExerciseText: .constant(true), showingStandText: .constant(true))
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .exercise, isRedacted: .constant(false), showingMoveText: .constant(true), showingExerciseText: .constant(true), showingStandText: .constant(true))
            ActivityProgressView(healthData: HealthStoreManager(), ringType: .standing, isRedacted: .constant(false), showingMoveText: .constant(true), showingExerciseText: .constant(true), showingStandText: .constant(true))
        }
    }
}
