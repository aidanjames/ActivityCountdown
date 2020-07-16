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
//            fetchHealthData()
            getActivity()
        } else {
            store = nil
        }
    }
    
    
    func requestAccess() {
        print("running request access")
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                            HKObjectType.quantityType(forIdentifier: .appleStandTime)!])

        if let store = store {
            store.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print("Granted")
//                    self.fetchHealthData()
                    self.getActivity()
                }
            }
        }

    }
    
    
    func fetchHealthData() {
        print("Running fetchHealthData")
        let calendar = NSCalendar.current
        let endDate = Date()
         
        guard let startDate = calendar.date(byAdding: .day, value: -1, to: endDate) else {
            fatalError("*** Unable to create the start date ***")
        }

        
        let units: Set<Calendar.Component> = [.day, .month, .year, .era]

        var startDateComponents = calendar.dateComponents(units, from: startDate)
        startDateComponents.calendar = calendar

        var endDateComponents = calendar.dateComponents(units, from: endDate)
        endDateComponents.calendar = calendar

        // Create the predicate for the query
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents,
                                                     end: endDateComponents)
        
        let query = HKActivitySummaryQuery(predicate: summariesWithinRange) { (query, summariesOrNil, errorOrNil) -> Void in
            
            print(query)
            guard let summaries = summariesOrNil else {
                // Handle any errors here.
                print("We have an error...")
                return
            }
            
            print("THIS IS SUMMARIES")
            print(summaries)
            
            for summary in summaries {
                // Process each summary here.
                print("**** THIS IS THE SUMMARIES ****")
                print(summary)
                
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                // Update the UI here.
            }
        }
        store!.execute(query)
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
            
            let endDate = NSDate()
            
            let components: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let startDate = Calendar.current.date(from: components)!

            
            // Plot the weekly step counts over the past 3 months
            statsCollection.enumerateStatistics(from: startDate, to: Date()) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
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
}
