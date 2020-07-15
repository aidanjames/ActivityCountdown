//
//  HealthStoreManager.swift
//  ActivityCountdown
//
//  Created by Aidan Pendlebury on 15/07/2020.
//

import HealthKit
import Foundation

class HealthStoreManager: ObservableObject {
    
    let store = HKHealthStore()
    
    @Published var calsBurned = 0
    @Published var minsWorkedOut = 0
    @Published var hoursStood = 0
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            requestAccess()
            fetchHealthData()
        }
    }
    
    
    func requestAccess() {
        print("running request access")
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                            HKObjectType.quantityType(forIdentifier: .appleStandTime)!])

        store.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
                print("Granted")
                self.fetchHealthData()
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
        
        store.execute(query)
    }
}
