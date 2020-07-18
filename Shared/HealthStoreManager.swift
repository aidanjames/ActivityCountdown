//
//  HealthStoreManager.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 15/07/2020.
//

import HealthKit
import Foundation

class HealthStoreManager: ObservableObject {
    
    let store: HKHealthStore?
    
    @Published var calsBurned: Double = 0
    @Published var minsWorkedOut: Double = 0
    @Published var hoursStood: Double = 0
    
    @Published var calsTarget: Double = 400
    @Published var workoutTarget: Double = 30
    @Published var standingTarget: Double = 12
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
            requestAccess()
//            executeActivitySummaryQuery()
        } else {
            store = nil
        }
    }
    
    
    func requestAccess() {
        

        let objectTypes: Set<HKObjectType> = [
            HKObjectType.activitySummaryType()
        ]

        if let store = store {
            store.requestAuthorization(toShare: nil, read: objectTypes) { (success, error) in
                if !success {
                    if let error = error { print("Access error: \(error.localizedDescription)") }
                }
                else {
                    self.executeActivitySummaryQuery()
                    self.getUpdates()
                }
            }
        }

    }

    
    func executeActivitySummaryQuery() {
        
        
        let calendar = Calendar.autoupdatingCurrent
                
        var dateComponents = calendar.dateComponents([ .year, .month, .day ], from: Date())

        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in

            guard let summaries = summaries, summaries.count > 0 else {
                if let error = error { print("\(error.localizedDescription)") }
                return
            }
                        
            let summary = summaries[0]

            let energyUnit = HKUnit.kilocalorie()
            let standUnit    = HKUnit.count()
            let exerciseUnit = HKUnit.second()

            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
            let stand    = summary.appleStandHours.doubleValue(for: standUnit)
            let exercise = summary.appleExerciseTime.doubleValue(for: exerciseUnit)

            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
            let standGoal    = summary.appleStandHoursGoal.doubleValue(for: standUnit)
            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
            
            print("\(energy) - \(energyGoal)")
            print("\(stand) - \(standGoal)")
            print("\(exercise) - \(exerciseGoal)")
            
            DispatchQueue.main.async {
                self.calsBurned = energy
                self.calsTarget = energyGoal
                self.minsWorkedOut = exercise / 60
                self.workoutTarget = exerciseGoal / 60
                self.hoursStood = stand
                self.standingTarget = standGoal
            }
            
        }
        
        store?.execute(query)
    }
    
    
    func getUpdates() {
        let types = [
            HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        for type in types {
            let query = HKObserverQuery(sampleType: type, predicate: nil) { (query, completionHandler, error) in
                print("I'm being called....")
                self.executeActivitySummaryQuery()
            }

            store?.execute(query)
            store?.enableBackgroundDelivery(for: type, frequency: .immediate) { (complete, error) in

            }
        }
    }

}
