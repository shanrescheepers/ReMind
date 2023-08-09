//
//  HealthKitManager.swift
//  Remind
//
//  Created by Mac on 2023/08/09.
//

import Foundation
import HealthKit
import SwiftUI
//Manager to access Health Data
class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
        
    @State private var restingHeartRates: Array<Double> = []
    @State private var lastRestingHeartRate: Double = 0.0
    
    @Published var activities: [Activity] = []
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            let steps = HKObjectType.quantityType(forIdentifier: .stepCount)!
            let calories = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let heartRateVariability = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
            let restingHeartRate = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
            
            let healthTypes: Set<HKObjectType> = [steps, calories, restingHeartRate, heartRateVariability]
            
            Task {
                do {
                    try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                    fetchDailySteps()
                    startHeartRateQuery()
                    startHeartRateQuery()
                } catch {
                    print("Error retrieving HealthKit: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //    functions to fetch each
    func fetchDailySteps()
    {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
    
//         _, : this is  a temporary variable
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate){
            _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today's steps data:  \(error?.localizedDescription ?? "")")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            print("Total Steps: \(stepCount) ")
            
//            append data into activity arrray
            self.activities.append(Activity(title: "Daily Steps", amount: "\(stepCount.rounded(.towardZero))",
                                            image: "figure.walk.circle.fill", color: .orange))
        }
        healthStore.execute(query)
    }
    
//    HeartRate
    private func startHeartRateQuery() {
            let calendar = NSCalendar.current
            
            var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
            
            anchorComponents.day! -= 6
            
            guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                fatalError("*** unable to create a valid date from the given components ***")
            }
            
            let interval = NSDateComponents()
            interval.day = 1
            
            let endDate = Date()
            
            guard let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate) else {
                fatalError("*** Unable to create a resting heart rate type ***")
            }
            
            // Create the query
            let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                    quantitySamplePredicate: nil,
                                                    options: .discreteAverage,
                                                    anchorDate: anchorDate,
                                                    intervalComponents: interval as DateComponents)
            
            // Set the results handlers
            query.initialResultsHandler = {
                _, results, error in
                guard let statsCollection = results else {
                    fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription ?? "") ***")
                }
                print("Initial resting heart rates updated")
                var values: Array<Double> = []
                // Add the average resting heart rate to array
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    
                    if let quantity = statistics.averageQuantity() {
                        let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                        values.append(value)
                    }
                }
                self.restingHeartRates = values
            }
            
            query.statisticsUpdateHandler = {
                _, _, results, error in guard let statsCollection = results else {
                    fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription ?? "") ***")
                }
            
            print("Resting Heart Rates updated \(self.restingHeartRates)")
                print("\(self.restingHeartRates)")
            var values: Array<Double> = []
            // Add the average resting heart rate to array
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                
                if let quantity = statistics.averageQuantity() {
                    let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                    values.append(value)
                }
            }
                self.restingHeartRates = values
                print(values)
            }
            
            healthStore.execute(query)
        }


                                   /*used only for testing, prints heart rate info */
  
}
