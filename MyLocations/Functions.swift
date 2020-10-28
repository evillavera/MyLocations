//
//  Functions.swift
//  MyLocations
//
//  Created by Erik Villavera on 10/21/20.
//

import Foundation

//will delay all functions for a time and then execute whatever is inside run
func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name("CoreDateSaveFailedNotification")

func fatalCoreDataError(_ error: Error){
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}
