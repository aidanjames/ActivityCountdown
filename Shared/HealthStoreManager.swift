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
    @Published var minsWorkedOut = 0
    @Published var hoursStood = 0
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
            requestAccess()
//            getActivity()
            executeActivitySummaryQuery()
            getUpdates()
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
                    // Handle the error here.
                    print("Error in getting access \(error?.localizedDescription)")
                } else {
                    print("Apparently successful? \(success.description)")
                    self.executeActivitySummaryQuery()
                }
            }
        }

    }
    
    
    
    func getActivity() {
        guard let activityData = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else { return }
        let workoutData = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)
        let standData = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime)
        
        
        
        let components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let startDate = Calendar.current.date(from: components)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let activityQuery = HKStatisticsCollectionQuery(quantityType: activityData, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        
        activityQuery.initialResultsHandler = { query, results, error in
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
            }
            
            _ = NSDate()
            
            let components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let startDate = Calendar.current.date(from: components)!

            
            // Plot the weekly step counts over the past 3 months
            statsCollection.enumerateStatistics(from: startDate, to: Date()) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    _ = statistics.startDate
//                    let value = quantity.doubleValue(for: HKUnit.count())
                    
                    print("Here is the quantity")
                    print(quantity)
                    DispatchQueue.main.async {
                        self.calsBurned = quantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    
                }
            }
        }
        
        store?.execute(activityQuery)
        
    }
    
    func executeActivitySummaryQuery() {
        
        
        let calendar = Calendar.autoupdatingCurrent
                
        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )

        // This line is required to make the whole thing work
        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in

            guard let summaries = summaries, summaries.count > 0 else {
                // No data returned. Perhaps check for error
                if let error = error { print("\(error.localizedDescription)") }
                return
            }
            
            print("Summaries: \(summaries)")
            


            // Handle the activity rings data here
//            let energyUnit   = HKUnit.jouleUnit(with: .kilo)
//            let standUnit    = HKUnit.count()
//            let exerciseUnit = HKUnit.second()
//
//
//            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
//            let stand    = summary.appleStandHours.doubleValue(for: standUnit)
//            let exercise = summary.appleExerciseTime.doubleValue(for: exerciseUnit)
//
//            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
//            let standGoal    = summary.appleStandHoursGoal.doubleValue(for: standUnit)
//            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
            
            
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

                // Handle new data here
                print("I'm being called....")
                self.executeActivitySummaryQuery()

            }

            store?.execute(query)
            store?.enableBackgroundDelivery(for: type, frequency: .immediate) { (complete, error) in

            }
        }
    }

}
